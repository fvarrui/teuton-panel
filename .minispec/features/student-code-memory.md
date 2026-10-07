# Remember the student's code

## Goal

Let a registered student get back to their page from any student page without typing their code again.

## Context

- After registering, the student must keep their code or the URL `/students/<code>`; the panel does not remember it.
- The student menu always shows "Home", "Register" and "Statement": a registered student keeps seeing "Register" and has no "My page".
- The home's "Already registered?" box starts empty every time.
- No sessions or login by design (ADR-004); the language already uses a cookie.

## Changes

- When a student opens their personal page or registers, store the code in a cookie (`code`, path `/`, one year).
- If the cookie holds a valid, existing code: the menu shows "My page" instead of "Register", and the home box is filled in.
- A "Not you?" link on the personal page clears the cookie.
- An unknown or deleted code in the cookie is ignored and cleared.
- The cookie is only a shortcut: personal routes still work by URL, and `curl` is unchanged.
- Record in ADR-004 that the code may be kept in a browser cookie (it gives no more access than the URL).
- Update the student guide and screenshots in en/es/ca.

## Acceptance

- After registering, going to Home and back shows "My page" in the menu.
- Clearing the cookie (or "Not you?") brings back "Register".
- A student never sees another student's page through the cookie (a forged cookie with someone else's code is the same as typing that URL).
- Rack::Test covers set, use, clear and unknown code.
