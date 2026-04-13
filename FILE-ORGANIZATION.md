# EWW Desktop UI - File Organization

This document explains what goes into each file type (.yuck vs .scss) and the purpose of each file.

## File Type Breakdown

### .yuck Files (Structure & Logic)
EWW's configuration language - defines widgets, variables, polling, and event handlers.

**Contains:**
- Widget definitions (`defwidget`)
- Polling variables (`defpoll`) - data that updates at intervals
- State variables (`defvar`) - data that changes based on user interaction
- Window definitions (`defwindow`)
- Event handlers (`:onclick`, `:onhover`, `:onfocus`, etc.)
- Data bindings and conditional logic
- Widget hierarchy and layout structure

**Does NOT contain:**
- Visual styling (colors, sizes, animations)
- CSS properties
- Transitions and effects

### .scss Files (Styling & Appearance)
SCSS/CSS - defines visual appearance, animations, and responsive behavior.

**Contains:**
- Colors and color schemes
- Sizes (width, height, padding, margin)
- Borders and border-radius
- Backgrounds and transparency
- Fonts and text styling
- Animations and transitions
- Hover effects and visual states
- Layout properties (flexbox, positioning)

**Does NOT contain:**
- Widget definitions
- Data polling or variables
- Event handlers
- Business logic

### .sh Files (Data Collection)
Bash scripts - collect system data and handle system interactions.

**Contains:**
- System API calls (sensors, nvidia-smi, etc.)
- Data parsing and formatting
- Error handling and fallbacks
- System commands (wmctrl, playerctl, etc.)

## File-by-File Breakdown

### Configuration Files

#### `eww.yuck` (Main Configuration)
- **Type**: Structure
- **Purpose**: Entry point, window definitions, includes other widgets
- **Contains**: Main window layout, widget imports

#### `eww.scss` (Main Stylesheet)
- **Type**: Styling
- **Purpose**: Global styles, variables, imports other stylesheets
- **Contains**: Color scheme, global variables, component imports

---

### Top Bar Component

#### `widgets/top-bar.yuck`
- **Type**: Structure
- **Purpose**: Top bar widget with telemetry, workspace switcher, media controls
- **Contains**:
  - `defpoll` variables for telemetry data (CPU, GPU, RAM, temps, etc.)
  - `defpoll` variables for workspace and media data
  - Widget definitions for telemetry-hud, workspace-switcher, media-controls
  - Temperature color logic (conditional classes)
  - Fan warning logic (conditional display)
  - Button click handlers for media and workspace controls

#### `styles/top-bar.scss`
- **Type**: Styling
- **Purpose**: Visual appearance of top bar components
- **Contains**:
  - Top bar container styling (background, padding, border)
  - Telemetry metric styling (colors, fonts, spacing)
  - Temperature color classes (cyan, yellow, orange, red)
  - Fan warning animation (blink effect)
  - Workspace indicator styling (island design, active state)
  - Media control button styling (hover effects, colors)
  - Volume control styling

---

### Left Sidebar Component

#### `widgets/left-sidebar.yuck`
- **Type**: Structure
- **Purpose**: Window selector with hover-activated drawer
- **Contains**:
  - `defvar` for sidebar state (idle/hover/expanded)
  - `defpoll` for window list and active window
  - Event handlers (`:onhover`, `:onhoverlost`)
  - Window list rendering with conditional visibility
  - Window switching button handlers
  - Logout button with click handler

#### `styles/left-sidebar.scss`
- **Type**: Styling
- **Purpose**: Visual appearance and state transitions
- **Contains**:
  - Width transitions for 3 states (5px → 50px → 350px)
  - Opacity transitions for content visibility
  - Window item styling (background, hover, active state)
  - Icon and title visibility per state
  - Logout button styling (colors, hover effect)
  - 300ms transition animations

---

### Right Sidebar Component

#### `widgets/right-sidebar.yuck`
- **Type**: Structure
- **Purpose**: Clock and app shortcuts with hover activation
- **Contains**:
  - `defvar` for sidebar state and app page
  - `defpoll` for time and date
  - `defvar` arrays for app shortcuts (page 1 and 2)
  - Event handlers for hover and page navigation
  - Clock display widgets
  - App shortcut buttons with launch handlers
  - Page navigation buttons

#### `styles/right-sidebar.scss`
- **Type**: Styling
- **Purpose**: Visual appearance and animations
- **Contains**:
  - Width transitions for 3 states
  - Clock display styling (large time, glowing effect)
  - App shortcut grid layout
  - App button hover effects (slide animation)
  - Page navigation styling
  - Content visibility per state

---

### Bottom Bar Component

#### `widgets/bottom-bar.yuck`
- **Type**: Structure
- **Purpose**: Search bar and app dock
- **Contains**:
  - `defvar` for search state and query
  - `defpoll` for search results and running apps
  - `defvar` array for dock app shortcuts
  - Search input handlers (`:onchange`, `:onfocus`, `:onblur`)
  - Search results rendering with conditional visibility
  - Dock app buttons with launch handlers
  - Hover tracking for magnification effect

#### `styles/bottom-bar.scss`
- **Type**: Styling
- **Purpose**: Visual appearance and animations
- **Contains**:
  - Search container island styling
  - Search results drawer animation (expands upward)
  - Search input styling
  - Dock app hover magnification (scale 1.5, 200ms)
  - Running app indicator styling
  - Active window highlighting
  - Transition animations

---

### Animation System

#### `styles/animations.scss`
- **Type**: Styling
- **Purpose**: Reusable animation definitions
- **Contains**:
  - Easing function variables
  - Transition mixins (fast, normal, slow)
  - Transform, width, height, opacity transitions
  - Hover effect mixins (scale, glow)
  - Visibility animation classes

---

### Data Collection Scripts

#### `scripts/telemetry.sh`
- **Type**: Data Collection
- **Purpose**: Collect system telemetry data
- **Contains**:
  - CPU percentage (using top)
  - GPU percentage (using nvidia-smi)
  - RAM usage (using free)
  - VRAM usage (using nvidia-smi)
  - FPS (placeholder)
  - Network speeds (using /proc/net/dev)
  - Temperatures (using sensors)
  - Fan speeds (using sensors)
  - Error handling for missing utilities

#### `scripts/workspace.sh`
- **Type**: System Control
- **Purpose**: Workspace detection and switching
- **Contains**:
  - Window manager detection (wmctrl/xdotool/sway)
  - Current workspace detection
  - Workspace count detection
  - Workspace switching commands

#### `scripts/media.sh`
- **Type**: System Control
- **Purpose**: Volume control
- **Contains**:
  - Volume level detection (using pactl)
  - Volume adjustment commands
  - Mute toggle

#### `scripts/windows.sh`
- **Type**: System Control
- **Purpose**: Window management
- **Contains**:
  - Window list with IDs, titles, icons
  - Active window detection
  - Window switching command (using wmctrl)
  - Icon path resolution

#### `scripts/apps.sh`
- **Type**: System Control
- **Purpose**: Application search and launching
- **Contains**:
  - Desktop file search
  - Application name and icon parsing
  - Running apps detection
  - Application launching (using gtk-launch)

---

## Quick Reference

### When to edit .yuck files:
- Adding new widgets
- Changing data sources (polling scripts)
- Modifying event handlers (clicks, hovers)
- Adjusting polling intervals
- Changing widget hierarchy
- Adding/removing app shortcuts

### When to edit .scss files:
- Changing colors
- Adjusting sizes and spacing
- Modifying animations
- Changing transition speeds
- Adjusting hover effects
- Updating fonts

### When to edit .sh files:
- Adding new data sources
- Changing system commands
- Modifying data parsing
- Adding error handling
- Supporting new utilities

---

## Data Flow Example

**Telemetry Display:**
1. `scripts/telemetry.sh` collects CPU percentage from system
2. `widgets/top-bar.yuck` polls the script every 2s via `defpoll`
3. `widgets/top-bar.yuck` displays value in metric widget
4. `styles/top-bar.scss` styles the metric with colors and fonts

**Sidebar Hover:**
1. User hovers over left sidebar
2. `widgets/left-sidebar.yuck` catches `:onhover` event
3. `widgets/left-sidebar.yuck` updates `left_sidebar_state` to "hover"
4. `styles/left-sidebar.scss` transitions width from 5px to 50px (300ms)
5. `styles/left-sidebar.scss` shows icon previews via opacity transition

**Window Switching:**
1. `scripts/windows.sh` lists all windows with IDs
2. `widgets/left-sidebar.yuck` polls window list every 2s
3. User clicks window button
4. `widgets/left-sidebar.yuck` executes `wmctrl -ia <window_id>`
5. `styles/left-sidebar.scss` highlights active window with cyan border
