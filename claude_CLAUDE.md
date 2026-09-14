- I don't use docker for local development - you can run `bin/rspec ...`, etc. No
  need to ever run `docker exec ...`
- Run `npm run prettier <files>` after editing any JS/TS files, and `npm run
eslint <files>` to check for linting errors.
- Run `bin/standardrb --fix <files>` after editing any Ruby files.
- Please avoid adding code comments unless ABSOLUTELY necessary.
- Don't add comments to tests/specs - they should be self-documenting.
