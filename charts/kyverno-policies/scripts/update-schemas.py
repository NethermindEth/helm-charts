#!/usr/bin/env python3
"""
Fetches Kyverno policy CRD schemas from the CRDs-catalog, strips descriptions
and x-kubernetes-* extensions, and writes values.schema.json for this chart.

Source: https://github.com/datreeio/CRDs-catalog/tree/main/policies.kyverno.io

Run from the chart root:
  ./scripts/update-schemas.py
"""

import json
import sys
import urllib.request
from dataclasses import dataclass
from pathlib import Path

CATALOG_BASE = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/policies.kyverno.io"


@dataclass(frozen=True)
class PolicyKind:
    # Key used in values.yaml (e.g. "validatingPolicies")
    values_key: str
    # Filename in the CRDs-catalog
    catalog_file: str
    # Name used for the spec definition in values.schema.json
    spec_def_name: str
    # Whether this is a namespaced policy variant
    namespaced: bool = False


POLICY_KINDS: list[PolicyKind] = [
    PolicyKind(
        values_key="validatingPolicies",
        catalog_file="validatingpolicy_v1.json",
        spec_def_name="validatingPolicySpec",
    ),
    PolicyKind(
        values_key="mutatingPolicies",
        catalog_file="mutatingpolicy_v1.json",
        spec_def_name="mutatingPolicySpec",
    ),
    PolicyKind(
        values_key="generatingPolicies",
        catalog_file="generatingpolicy_v1.json",
        spec_def_name="generatingPolicySpec",
    ),
    PolicyKind(
        values_key="deletingPolicies",
        catalog_file="deletingpolicy_v1.json",
        spec_def_name="deletingPolicySpec",
    ),
    PolicyKind(
        values_key="imageValidatingPolicies",
        catalog_file="imagevalidatingpolicy_v1.json",
        spec_def_name="imageValidatingPolicySpec",
    ),
    PolicyKind(
        values_key="namespacedValidatingPolicies",
        catalog_file="namespacedvalidatingpolicy_v1.json",
        spec_def_name="validatingPolicySpec",
        namespaced=True,
    ),
    PolicyKind(
        values_key="namespacedMutatingPolicies",
        catalog_file="namespacedmutatingpolicy_v1.json",
        spec_def_name="mutatingPolicySpec",
        namespaced=True,
    ),
    PolicyKind(
        values_key="namespacedGeneratingPolicies",
        catalog_file="namespacedgeneratingpolicy_v1.json",
        spec_def_name="generatingPolicySpec",
        namespaced=True,
    ),
    PolicyKind(
        values_key="namespacedDeletingPolicies",
        catalog_file="namespaceddeletingpolicy_v1.json",
        spec_def_name="deletingPolicySpec",
        namespaced=True,
    ),
    PolicyKind(
        values_key="namespacedImageValidatingPolicies",
        catalog_file="namespacedimagevalidatingpolicy_v1.json",
        spec_def_name="imageValidatingPolicySpec",
        namespaced=True,
    ),
]

ALLOWED_SEVERITIES = ["critical", "high", "medium", "low", "info"]
ALLOWED_CATEGORIES = ["Security", "Best Practices", "Governance", "Misc", "Reliability"]


def fetch_json(url: str) -> dict:
    print(f"  Fetching {url}")
    with urllib.request.urlopen(url) as resp:
        return json.loads(resp.read())


def strip_schema(obj: object) -> object:
    if isinstance(obj, dict):
        return {
            k: strip_schema(v)
            for k, v in obj.items()
            if k != "description" and not k.startswith("x-kubernetes")
        }
    if isinstance(obj, list):
        return [strip_schema(i) for i in obj]
    return obj


def policy_entry_def(spec_def_name: str, namespaced: bool = False) -> dict:
    props = {
        "title": {"type": "string"},
        "description": {"type": "string"},
        "severity": {"$ref": "#/definitions/severity"},
        "category": {"$ref": "#/definitions/category"},
        "spec": {"$ref": f"#/definitions/{spec_def_name}"},
    }
    if namespaced:
        props["namespace"] = {"type": "string"}
    return {
        "type": "object",
        "additionalProperties": False,
        "required": ["title", "description", "severity", "category", "spec"],
        "properties": props,
    }


def policies_map_def(entry_def_name: str) -> dict:
    return {
        "type": "object",
        "additionalProperties": {"$ref": f"#/definitions/{entry_def_name}"},
    }


def main():
    chart_dir = Path(__file__).parent.parent
    output_path = chart_dir / "values.schema.json"

    definitions = {
        "severity": {"type": "string", "enum": ALLOWED_SEVERITIES},
        "category": {"type": "string", "enum": ALLOWED_CATEGORIES},
    }

    # Fetch and strip spec schemas — deduplicated by spec_def_name
    fetched: set[str] = set()
    print("Fetching CRD schemas from CRDs-catalog...")
    for kind in POLICY_KINDS:
        if kind.spec_def_name in fetched:
            continue
        url = f"{CATALOG_BASE}/{kind.catalog_file}"
        try:
            raw = fetch_json(url)
        except Exception as e:
            print(f"ERROR fetching {url}: {e}", file=sys.stderr)
            sys.exit(1)

        spec_schema = raw.get("properties", {}).get("spec")
        if not spec_schema:
            print(f"ERROR: no .properties.spec in {kind.catalog_file}", file=sys.stderr)
            sys.exit(1)

        definitions[kind.spec_def_name] = strip_schema(spec_schema)
        fetched.add(kind.spec_def_name)

    properties = {"nameOverride": {"type": "string"}}

    for kind in POLICY_KINDS:
        suffix = "NamespacedEntry" if kind.namespaced else "Entry"
        entry_def_name = kind.spec_def_name.replace("Spec", suffix)
        map_def_name = f"{kind.values_key}Map"

        definitions[entry_def_name] = policy_entry_def(
            kind.spec_def_name, namespaced=kind.namespaced
        )
        definitions[map_def_name] = policies_map_def(entry_def_name)
        properties[kind.values_key] = {"$ref": f"#/definitions/{map_def_name}"}

    schema = {
        "$schema": "http://json-schema.org/draft-07/schema#",
        "type": "object",
        "additionalProperties": False,
        "properties": properties,
        "definitions": definitions,
    }

    output_path.write_text(json.dumps(schema, indent=2) + "\n")

    print(f"\nWrote {output_path} ({output_path.stat().st_size:,} bytes)")


if __name__ == "__main__":
    main()
