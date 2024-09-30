# PlantUML Identity Sprites Repository

Welcome to the **PlantUML Identity Sprites** repository! This project automates the conversion of `.png` and `.svg` icon files into PlantUML sprite files (`.puml`), providing a powerful way to use custom icons in your PlantUML diagrams. The scripts also generate markdown indexes and logs for easy navigation and reference.

## Repository Overview

This repository contains:
- **Scripts**: Automate the creation of PlantUML sprites from icon files.
- **Icons**: Both `.png` and `.svg` icons, categorized in the `icons` folder.
- **Generated Sprite Files**: PlantUML `.puml` files corresponding to each icon, located in the `puml` directory.
- **Generated Diagrams**: Example diagrams showcasing the use of these sprites.
- **Common Macros**: A `common.puml` file that contains reusable macros for creating aliased and colorized entities with or without labels.

### Folder Structure

```plaintext
.
├── Icons.md
├── IdentitySprites.ipynb
├── LICENSE
├── README.md
├── common.puml                # Contains reusable macros for creating entities.
├── create_sprites.sh           # Main script for generating PlantUML sprites.
├── icons/                      # Contains all input icons.
│   ├── png/                    # PNG icons used for sprite generation.
│   └── svg/                    # Optional SVG icons.
├── puml/                       # Contains generated PlantUML sprite files.
├── identity_sprites_diagram/    # Example diagrams created using the generated sprites.
└── meta/                       # Generated logs and reports.
```

## Getting Started

### Prerequisites

Ensure you have the following tools installed on your system:
- **[PlantUML](http://plantuml.com/)**: For rendering diagrams.
- **Bash**: For running the `create_sprites.sh` script.
  
### Usage

To generate PlantUML sprite files from your icons, run the following command:

```bash
./create_sprites.sh PREFIX
```

Where `PREFIX` is the custom prefix you'd like to use for your sprite macros. For example, if you use `ID`, the generated macros will be in the form `ID_ICONNAME`.

### Example

```bash
./create_sprites.sh IDENTITY
```

This will generate sprite files for each icon and store them in the `puml/` directory. It will also generate a markdown index (`meta/index.md`) and a log file (`meta/sprite_report.log`).

## Common Macros: `common.puml`

The `common.puml` file contains macros that simplify the process of creating entities with sprites, color, aliases, and labels.

### 1. `ENTITY` Macro (Without Label)

This macro creates an aliased entity with a sprite, colored by a specified color, and assigns it a stereotype for additional styling. This version does **not** display a label.

#### Parameters:
- **e_type**: The entity type (e.g., `component`, `node`, `agent`, etc.).
- **e_color**: The color of the sprite.
- **e_sprite**: The sprite for the icon.
- **e_alias**: The alias used for this entity in the diagram.
- **e_stereo**: The stereotype, which can define additional styling.

#### Syntax:
```plaintext
ENTITY(e_type, e_color, e_sprite, e_alias, e_stereo)
```

#### Example:
```plaintext
ENTITY(component, "#00FF00", icon_api, MyAlias, "API")
```

This will render a green `component` entity using the `icon_api` sprite with the alias `MyAlias` and stereotype `API`.

### 2. `ENTITY` Macro (With Label)

This macro extends the above by allowing a label to be displayed under the sprite.

#### Parameters:
- **e_type**: The entity type (e.g., `component`, `node`, `agent`, etc.).
- **e_color**: The color of the sprite.
- **e_sprite**: The sprite for the icon.
- **e_label**: The label to display under the sprite.
- **e_alias**: The alias used for this entity in the diagram.
- **e_stereo**: The stereotype, which can define additional styling.

#### Syntax:
```plaintext
ENTITY(e_type, e_color, e_sprite, e_label, e_alias, e_stereo)
```

#### Example:
```plaintext
ENTITY(node, "#FFDD00", icon_backend, "Backend Service", MyBackend, "Backend")
```

This will render a yellow `node` entity using the `icon_backend` sprite with the label "Backend Service", the alias `MyBackend`, and the stereotype `Backend`.

### Hiding Stereotypes

By default, stereotypes are hidden using the `hide stereotype` directive at the end of `common.puml`. You can customize this if you prefer to display stereotypes.

## Sprite Index

Here is a list of all generated PlantUML sprites. Each sprite can be referenced in your diagrams using the associated macro.

| Icon Name                     | Sprite Macro             | PlantUML Code |
|-------------------------------|--------------------------|---------------|
| `icon_access_token`            | `BC_ICON_ACCESS_TOKEN`  | `!define BC_ICON_ACCESS_TOKEN(_color, _scale) SPRITE_PUT(BC_ICON_access_token, _color, _scale)` |
| `icon_account_takeover`        | `BC_ICON_ACCOUNT_TAKEOVER`  | `!define BC_ICON_ACCOUNT_TAKEOVER(_color, _scale) SPRITE_PUT(BC_ICON_account_takeover, _color, _scale)` |
| `icon_actions`                 | `BC_ICON_ACTIONS`  | `!define BC_ICON_ACTIONS(_color, _scale) SPRITE_PUT(BC_ICON_actions, _color, _scale)` |
| `icon_activity`                | `BC_ICON_ACTIVITY`  | `!define BC_ICON_ACTIVITY(_color, _scale) SPRITE_PUT(BC_ICON_activity, _color, _scale)` |
| `icon_api`                     | `BC_ICON_API`  | `!define BC_ICON_API(_color, _scale) SPRITE_PUT(BC_ICON_api, _color, _scale)` |
| `icon_auth0`                   | `BC_ICON_AUTH0`  | `!define BC_ICON_AUTH0(_color, _scale) SPRITE_PUT(BC_ICON_auth0, _color, _scale)` |
| `icon_authorization_server`     | `BC_ICON_AUTHORIZATION_SERVER`  | `!define BC_ICON_AUTHORIZATION_SERVER(_color, _scale) SPRITE_PUT(BC_ICON_authorization_server, _color, _scale)` |
| `icon_backend`                 | `BC_ICON_BACKEND`  | `!define BC_ICON_BACKEND(_color, _scale) SPRITE_PUT(BC_ICON_backend, _color, _scale)` |
| `icon_biometrics`              | `BC_ICON_BIOMETRICS`  | `!define BC_ICON_BIOMETRICS(_color, _scale) SPRITE_PUT(BC_ICON_biometrics, _color, _scale)` |
| `icon_certificate`             | `BC_ICON_CERTIFICATE`  | `!define BC_ICON_CERTIFICATE(_color, _scale) SPRITE_PUT(BC_ICON_certificate, _color, _scale)` |

_For the full list of sprites, please refer to the [sprite index](meta/index.md)._

## Example Diagram

Here is an example PlantUML diagram using the generated sprites:

```plantuml
@startuml
!include https://raw.githubusercontent.com/sleepstate/plantuml-identity-sprites/refs/heads/main/common.puml

!include https://raw.githubusercontent.com/sleepstate/plantuml-identity-sprites/main/puml/icon_access_token.puml
!include https://raw.githubusercontent.com/sleepstate/plantuml-identity-sprites/main/puml/icon_backend.puml
!include https://raw.githubusercontent.com/sleepstate/plantuml-identity-sprites/main/puml/icon_api.puml

BC_ICON_ACCESS_TOKEN()
BC_ICON_BACKEND("#FFDD00", 1.5)
BC_ICON_API("blue", 1.0)
@enduml
```

This code will render the icons `icon_access_token`, `icon_backend`, and `icon_api` with the specified colors and scales.

## Customizing the Sprites

The generated PlantUML sprite macros allow for customization with the following parameters:
- **_color**: The color of the sprite (e.g., `red`, `#FF0000`).
- **_scale**: Scaling factor for the size of the sprite.

### Example Customization

```plaintext
@startuml
BC_ICON_ACCESS_TOKEN("#00FF00", 2)    ' Large green icon
BC_ICON_BACKEND("blue", 1.5)          ' Scaled blue icon
@enduml
```

## Troubleshooting

If you encounter any issues, check the `meta/sprite_report.log` for detailed logs of the sprite generation process.

## Contributing

We welcome contributions! Please submit pull requests for new icons, bug fixes, or other improvements.

### Adding New Icons

1. Add your PNG or SVG icons to the `icons/png` or `icons/svg` directories, respectively.
2. Run the `create_sprites.sh` script with your preferred prefix.
3. Commit the generated files in `puml/`, `meta/`, and any updated diagrams.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

For more details on using PlantUML sprites, check out the [official documentation](http://plantuml.com/sprite).