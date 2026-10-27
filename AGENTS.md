# E-Kinerja Project Guidelines

## Scope and Current Focus

This repository contains the system-design documentation for the E-Kinerja application. Diagram work is primarily under `diagram/`:

- `diagram/usecase/`: use-case diagrams and source XML.
- `diagram/activity/`: CRUD activity diagrams, Draw.io XML, and exported PNGs.
- `diagram/sequence_diagram/`: sequence-diagram Draw.io files, PlantUML sources, images, and supporting documentation.
- `diagram/usecase-scenario.md`: use-case scenarios and links to activity-diagram exports.
- `diagram/diagram.md`: RAD research-flow and sequence-diagram notation rules.

Keep related source, documentation, and rendered output consistent when changing a diagram.

## Diagram Conventions

### Use-case diagrams

- Use action-oriented names, especially `Kelola [Entity]` rather than a bare entity name.
- Include common system use cases such as `Login` where applicable.
- Preserve the actor roles used by the project, including Petugas, Operator, and Kepala Sesi.

### Activity diagrams

Standard `Kelola` flows should use actor/system swimlanes and normally include:

- Add, edit, and delete decision paths.
- Forms for adding and editing data.
- Delete confirmation dialogs.
- Success notifications and refreshed lists.

Use the existing activity diagrams and reference images as the layout and naming reference. Use `diagram/activity/export_activity_diagrams.py` when regenerating the standard exported PNGs.

### Sequence diagrams

Follow the notation rules in `diagram/diagram.md`:

- Use UML stereotypes: `actor`, `boundary`, `control`, and `entity`.
- Use solid arrows for primary messages and dashed/open arrows for responses.
- Use `alt` frames for alternatives; do not represent alternatives with flowchart diamonds.
- Keep each diagram to a maximum of four objects: actor, boundary, control, and entity.
- Use general, readable message descriptions rather than implementation-specific wording.
- Use `Sistem` for the control object and `Database` for the entity object unless the existing diagram requires otherwise.

PlantUML sources belong in `diagram/sequence_diagram/puml/`; keep corresponding documentation and rendered diagrams synchronized.

## Editing and Validation

- Prefer creating or updating an `_updated` copy of Draw.io XML instead of overwriting an original, unless explicitly requested.
- Preserve existing user changes and avoid unrelated cleanup.
- Use ASCII by default and match the existing file format and naming style.
- After changing a diagram, validate the XML/PlantUML source and regenerate affected exports when practical.
- Update `diagram/usecase-scenario.md` when adding or renaming documented use cases or activity exports.
- Treat backup files (`.$*.bkp`) and generated images as artifacts; do not edit them directly.
