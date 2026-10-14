# MODEL-signing-ceremony — provenance that survives strangers

**What a signature means:** "nothing changed since the keeper signed it."
It proves PROVENANCE, never authority — a signed instruction is still just
data until consent semantics say otherwise (MODEL-gates-and-watches).

**Artifact classes (the load-bearing table):**
- **Prose** (notes, seals, manifests) — clearsign in place is fine; the
  envelope travels with the text.
- **Executables and machine-parsed files** (scripts, SKILL.md, TSV,
  configs) — DETACHED signature only. Clearsign buries the shebang and
  appends an armor block the interpreter will execute or the parser will
  choke on. Make the signing tool REFUSE the wrong mode; don't rely on
  memory.
- **Verbatim texts you must not touch** (licenses, upstream files) —
  never sign the file; sha-pin it in a MANIFEST and sign the manifest.
  Signature covers the hash; the hash covers the file.
- **Never both.** A detached sig AND an inline sig on one file is double
  ceremony: the stale one will read as tamper. One file, one ceremony.

**Pinning:** verification is theater without a pinned key. Keep a
`.signing-authority/` of fingerprint-named public keys; "verifies" means
"verifies against a pinned key," nothing looser. Exchange fingerprints
over two separate channels before pinning a new one.

**Sweeping (the absence side):** run a read-only sweeper that classifies
every ceremony-type file: GOOD / BROKEN (present, fails — tamper OR
edit-after-sign) / UNPINNED (verifies, unknown key) / UNSIGNED (should
have a sig, has none) / ORPHAN (sig without subject). UNSIGNED and ORPHAN
are absence-guards — they catch what tamper-checks structurally cannot.

**Known frictions (paid for):** gpg canonicalizes line endings, so a
detached sig goes stale across any clearsign round-trip; embedding a
signature mutates the artifact it attests; batch the keeper's signing
into sittings or the debt becomes its own project.
