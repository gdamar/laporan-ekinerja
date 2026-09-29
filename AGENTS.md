# E-Kinerja Project Summary & Guidelines

## Current Focus
We are currently working on updating the system design diagrams for the E-Kinerja application, specifically focusing on the `laporan-ekinerja/diagram` directory.

## Key Tasks & Progress
1. **Use Case Diagrams (`diagram/usecase`)**:
   - Refined use case diagrams (e.g., `use_case_updated.drawio.xml`).
   - Standardized naming conventions (e.g., using "Kelola [Entity]" instead of just the entity name, like "Kelola Tugas").
   - Added standard use cases like Login.
2. **Activity Diagrams (`diagram/activity`)**:
   - Updating activity diagrams for specific actors (e.g., Operator/Kepala Seksi) in files like `activity_rest.drawio.xml`.
   - Applying a standardized flow for "Kelola" (Manage) use cases based on provided reference images. This standardized flow typically includes:
     - Actor (Admin/User) and System swimlanes.
     - Decision points for Add, Edit, and Delete actions.
     - Confirmation dialogs for deletion.
     - Form displays for adding/editing.
     - Success notifications and list refreshes.
   - Using automated scripts (e.g., `gen_activity.py`) to help generate the repetitive XML structure for these standard CRUD activity diagrams in Draw.io format.

## General Guidelines
- **Draw.io Modifications**: When updating Draw.io XML files, prefer storing the changes in a new file (e.g., `_updated.xml`) rather than overwriting the original, unless explicitly requested otherwise.
- **Reference Materials**: Strictly follow attached reference images for structural layout and naming conventions when updating diagrams.
