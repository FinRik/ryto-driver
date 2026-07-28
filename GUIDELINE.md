You are onboarding to an existing Flutter project. Before making any changes, thoroughly analyze the entire codebase to build a complete understanding of its architecture, patterns, and conventions.

### Project Overview

* This is a Flutter application.
* State management is implemented using **flutter_bloc (Bloc/Cubit)**.
* The project follows a feature-based architecture with separation between presentation, business logic, data, and domain where applicable.

### Your Objectives

1. Explore the entire project structure and understand how features are organized.
2. Identify the application's entry point, routing/navigation flow, dependency injection, and initialization process.
3. Understand how Blocs/Cubits are created, provided, communicate with repositories, and manage state.
4. Trace the flow of data from the UI to the Bloc, through repositories/services, and back to the UI.
5. Identify shared components, utilities, extensions, models, and reusable widgets.
6. Understand how networking, local storage, authentication, and configuration are implemented.
7. Review the project's coding conventions and architectural patterns so future changes remain consistent.

### While Reviewing

* Do not modify any code yet.
* Document the purpose of each major module and feature.
* Note any architectural inconsistencies, technical debt, duplicated logic, or potential improvements.
* Identify areas where state management could be simplified or made more consistent.
* Highlight any potential state leaks, memory leaks, lifecycle issues, or crash risks.
* Point out reusable components that should be preferred over creating new implementations.

### Deliverables

Provide a summary including:

* Overall architecture.
* Folder structure and responsibilities.
* State management flow (Bloc/Cubit).
* Dependency flow.
* Navigation flow.
* Key reusable components.
* Important business logic.
* External dependencies and integrations.
* Potential risks or code smells.
* Recommendations for future development.

Do not begin implementing features until you have completed this analysis and have enough context to make changes that align with the existing architecture and coding style.
