---
layout: post
title: "Starting the Entra ID Graph API Toolkit"
date: 2026-08-29
categories: entra-id graph-api
---

This is the first post on this blog, kicking off a project to document Microsoft Entra ID's Graph API surface end to end — every major admin center category, mapped to its actual REST endpoints, v1.0 and beta, with real notes on what's easy to get wrong.

## Why build this

Microsoft's own documentation is thorough, but scattered — endpoints for a single feature area (like Conditional Access, or Identity Governance) are often split across many separate pages. The goal here is a single, organized reference: one folder per admin center category, one file per topic, with a consistent table format covering v1.0 vs beta endpoints, required permissions, and practical gotchas.

## What's covered so far

The toolkit currently spans 26 folders, matching the full Microsoft Entra admin center navigation — from Users and Groups through to Security, Identity Governance, and Sign-In Logs. Alongside it, a companion PowerShell scripts repository is underway, covering real automation workflows: bulk provisioning, license management, PIM, device auditing, and more — each script paired with a full written explanation of how and why it works.

## What's next

Future posts will dig into specific lessons learned along the way — quirks in the Graph API that aren't obvious from the docs, PowerShell patterns worth reusing, and notes on setting up a public repo safely (branch protection, contribution workflows) for reference material other people might actually use.
