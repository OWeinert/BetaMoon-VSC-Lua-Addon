---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: CLIENT UI
-- --------------------------------------------------------------------------

---@alias BetaMoonUiColor integer|string ARGB integer or #RRGGBB/#AARRGGBB.
---@alias BetaMoonUiCapability 'input'|'modal_layers'|'world_data'|'native_inventory'|'native_items'|'prepared_drawing'|'raw_drawing'
---@alias BetaMoonUiControl 'text'|'image'|'panel'|'row'|'column'|'grid'|'scroll'|'list'|'tree'|'table'|'overlay'|'spacer'|'divider'|'button'|'checkbox'|'choice'|'radio'|'slider'|'stepper'|'textbox'|'textarea'|'numberbox'|'dropdown'|'contextmenu'|'tabs'|'progress'|'dialog'|'tooltip'
---@alias BetaMoonUiSchema table<string, BetaMoonUiField>
---@class BetaMoonUiField
---@field type 'number'|'integer'|'boolean'|'string'|'color'|'string_list'|'data'
---@field default? any
---@field min? number Numeric fields only; default -1000000.
---@field max? number Numeric fields only; default 1000000.
---@field optional? boolean
---@field required? boolean
---@field animated? boolean Numeric component props only.

---@class BetaMoonUiModel
---@field get fun(self: BetaMoonUiModel, name: string): any Detached value; unknown fields fail.
---@field snapshot fun(self: BetaMoonUiModel): table<string, any> Read-only detached snapshot.
---@field set fun(self: BetaMoonUiModel, changesOrName: table<string, any>|string, value?: any) Typed partial publication.

---@class BetaMoonUiLocalState
---@field get fun(self: BetaMoonUiLocalState, name: string): any
---@field set fun(self: BetaMoonUiLocalState, name: string, value: any) Event-local changes roll back on handler failure.

---@class BetaMoonUiBindingView: BetaMoonGuiBindingView
---@field props table<string, any> Detached component props.
---@field state BetaMoonGuiReadAccess Component-local state, or screen state for root/caller-owned content.
---@field inventory? BetaMoonUiInventoryContext Scoped inventory layout in an attached inventory document.
---@field hud? BetaMoonUiHudContext Scoped HUD snapshot; reading it observes logical snapshot changes.
---@field notification? BetaMoonUiNotificationContext Scoped notification presentation metadata.

---@class BetaMoonUiContext
---@field native BetaMoonNativeAccess Read-only native entry except in a declared action's explicit action scope.
---@field screen BetaMoonUiScreenInstance
---@field menu? BetaMoonUiMenuContext Scoped native menu actions in a contributed document.
---@field inventory? BetaMoonUiInventoryContext Scoped detached geometry in a player inventory document.
---@field hud? BetaMoonUiHudContext Scoped detached observations in an additive/native replacement HUD document.
---@field notification? BetaMoonUiNotificationContext Scoped metadata in a notification document.
---@field state BetaMoonUiLocalState
---@field data BetaMoonUiModel Root data is writable only by its owning script.
---@field props table<string, any>
---@field gui {element: fun(self: table, id: string): BetaMoonGuiElementHandle} Local IDs and explicit component exports.
---@field emit fun(self: BetaMoonUiContext, name: string, payload?: table<string, any>): boolean? Declared component event.
---@field world? BetaMoonActionWorld Read access in UI callbacks; gameplay writes require a world action.
---@field player? BetaMoonActionEntity

---@class BetaMoonUiEvent
---@field type string activate/change/expand/sort/input/open/refresh/update/close or a declared component event.
---@field elementId? string Local authored ID.
---@field value? any
---@field payload? table<string, any>
---@field reason? string Close reason.

---@class BetaMoonUiSelectionOption
---@field key string Unique nonempty stable key, at most 255 UTF-16 units.
---@field label? string Defaults to key; at most 8192 UTF-16 units. Duplicate labels are allowed.
---@field enabled? boolean Defaults to true; disabled options cannot be selected.

---@class BetaMoonUiRadioOptionBounds
---@field key string Stable option key, in declaration order.
---@field x integer Local left edge.
---@field y integer Local top edge.
---@field width integer Clipped option width.
---@field height integer Clipped option height.
---@field focusTarget boolean Selected option, or first enabled option when selection is empty.

---@class BetaMoonUiTableColumn
---@field key string Unique nonempty column key, at most 255 UTF-16 units.
---@field label? string Header label; defaults to key.
---@field field? string Top-level primitive record.data field; defaults to key.
---@field width? integer Fixed GUI pixels 1..16384, or 0 for an equal flexible share (default).

---@class BetaMoonUiCollectionRecord
---@field key string Unique nonempty stable key, at most 255 UTF-16 units.
---@field parent? string Tree parent key; omit for lists and root records.
---@field label? string Defaults to key; at most 8192 UTF-16 units.
---@field enabled? boolean Defaults to true.
---@field data? table<string, any> Detached read-only row data; defaults to an empty record.

---@class BetaMoonUiCollectionRow
---@field key string
---@field parent? string
---@field label string
---@field enabled boolean
---@field data table<string, any>
---@field depth integer Zero-based tree depth.
---@field selected boolean
---@field expanded boolean

---@class BetaMoonUiNode
---@field type? BetaMoonUiControl Exactly one of type/component/slot.
---@field component? string Registered component key.
---@field slot? string Builder content-placement token; index optionally selects one child.
---@field index? integer
---@field id? string Scope-local lookup ID.
---@field key? string Stable sibling key for compatible local-state retention.
---@field props? table<string, any> Declared component props.
---@field slots? table<string, BetaMoonUiNode[]>
---@field children? BetaMoonUiNode[] Built-in children; scroll requires one concrete child tree, and list/tree/table content uses row instead.
---@field on? table<string, fun(ctx: BetaMoonUiContext, event: BetaMoonUiEvent): boolean?>
---@field bind? fun(view: BetaMoonUiBindingView): table<string, any>, BetaMoonGuiTransitionPolicy|false|nil
---@field transition? BetaMoonGuiTransitionPolicy|false
---@field theme? string Inherited theme key or built-in preset.
---@field template? string Theme template name; defaults to control kind.
---@field style? BetaMoonUiStyle Literal inline overrides.
---@field styleRef? string Named variant, taking precedence over variant when nonempty.
---@field variant? string Default 'default'.
---@field width? number Zero means intrinsic; explicit dimensions 0..16384.
---@field height? number
---@field minWidth? number
---@field minHeight? number
---@field x? number Local layout offset.
---@field y? number
---@field anchorX? number Root viewport anchor in 0..1; default 0.5.
---@field anchorY? number
---@field translateX? number
---@field translateY? number
---@field scaleX? number Positive visual scale.
---@field scaleY? number
---@field opacity? number 0..1.
---@field grow? number
---@field padding? number Layout padding 0..1024.
---@field gap? number
---@field columns? integer|BetaMoonUiTableColumn[] Grid column count, or a table control's 1..64 keyed columns.
---@field minimumCellWidth? integer Grid: responsive width 1..16384 when columns=0; otherwise 0 (default).
---@field records? BetaMoonUiCollectionRecord[] List/tree/table: dense ordered model, at most 4096 unique keys.
---@field row? fun(row: BetaMoonUiCollectionRow): BetaMoonUiNode Read-only realization outside paint; omit for default rows.
---@field rowState? table<string, any> Typed row-local state schema; requires row.
---@field rowHeight? integer List/tree/table: fixed height 1..1024, default 20.
---@field overscan? integer List/tree/table: extra realized rows on each side, 0..8; default 1.
---@field selectedKey? string List/tree/table/radio/tabs/dropdown/contextmenu: selected key; empty string clears selection. Bound values require acknowledgement.
---@field expandedKeys? string[] Tree: unique expanded branch keys; default empty.
---@field headerHeight? integer Table header height 1..1024, default 20.
---@field sortColumn? string Table column key; empty string means no selected sort column.
---@field sortDirection? 'none'|'ascending'|'descending' Table sort direction, default none; requires a column when active.
---@field filter? string Table: case-insensitive substring filter over labels and declared primitive cells.
---@field fill? boolean
---@field align? 'start'|'center'|'end'|'stretch'
---@field justify? 'start'|'center'|'end'
---@field clip? boolean
---@field visible? boolean
---@field visibility? 'visible'|'hidden'|'collapsed'
---@field enabled? boolean
---@field text? string Text, button, checkbox, choice, stepper prefix, textbox, textarea, dropdown/contextmenu placeholder, progress label prefix, dialog, tooltip.
---@field image? string Prepared image/drawable name.
---@field selected? boolean Checkbox value.
---@field value? number Slider/stepper/numberbox/progress value, or 1-based choice index. Numberbox proposes on.change on Enter/blur and keeps a 128-unit text draft.
---@field options? string[]|BetaMoonUiSelectionOption[] Choice labels, or 0..256 keyed radio/tabs/dropdown/contextmenu options.
---@field minimum? number Slider/stepper/numberbox/progress minimum; default 0.
---@field maximum? number Slider/stepper/numberbox/progress maximum; default 100.
---@field step? number Slider/stepper default 1. Numberbox default 0 disables rounding; positive steps accept 0.000001..1000000000000.
---@field orientation? 'horizontal'|'vertical' Slider/progress/tabs default horizontal; radio defaults vertical.
---@field optionHeight? integer Radio/tabs option height 1..1024, default 20.
---@field maximumLength? integer Textbox/textarea UTF-16 limit 0..65536; default 4096. Textarea normalizes CRLF/CR to LF before checking.
---@field wrap? boolean Textarea: wrap to viewport width (default true); false allows horizontal scrolling.
---@field presentation? 'linear'|'segmented'|'radial'|'label' Progress presentation, default linear.
---@field indeterminate? boolean Progress: Java-clock indicator, default false.
---@field segments? integer Progress segmented presentation: 1..256, default 10.
---@field direction? 'vertical'|'horizontal'|'both' Scroll axes; default vertical.
---@field contentWidth? integer Scroll: 0 for measured extent, or explicit 1..16384 pixels.
---@field contentHeight? integer Scroll: 0 for measured extent, or explicit 1..16384 pixels.
---@field scrollX? integer Scroll/table: initial or controlled horizontal offset 0..16384; clamped to content. Table proposes on.scroll {scrollX}.
---@field scrollY? integer Scroll: initial/controlled vertical offset 0..16384; clamped to limits.
---@field scrollbars? boolean Scroll/list/tree/table/textarea: show default tracks/thumbs (default true); wheel/keyboard work when false.

---@class BetaMoonUiComponentDefinition
---@field key string
---@field label? string
---@field props? BetaMoonUiSchema
---@field state? BetaMoonUiSchema
---@field events? table<string, BetaMoonUiSchema>
---@field slots? table<string, {min: integer?, max: integer?}>
---@field exports? table<string, string> Export name to local element ID.
---@field requires? BetaMoonUiCapability[]
---@field dependencies? string[] Declared reusable component keys.
---@field build? fun(props: table<string, any>, content: table): BetaMoonUiNode Read-only expansion outside paint.
---@field paint? fun(view: BetaMoonUiPaintView): BetaMoonUiPaintCommand[] Prepared leaf; mutually exclusive with build/rawDraw.
---@field rawDraw? fun(frame: BetaMoonUiRawFrame) Explicit per-frame Lua graphics callback; no UI/gameplay writes.
---@field hit? fun(view: BetaMoonUiPaintView): BetaMoonUiPaintCommand[] Prepared hit regions for raw leaves; no drawing required.
---@field input? fun(ctx: BetaMoonUiContext, event: table): boolean|{consume: boolean?, capture: boolean?, release: boolean?, focus: boolean?}
---@field focusable? boolean
---@field size? {width: integer?, height: integer?, minWidth: integer?, minHeight: integer?} Custom leaves default to 16x16; composite hints default to zero.

---@class BetaMoonUiStyle
---@field background? BetaMoonUiColor
---@field foreground? BetaMoonUiColor
---@field border? BetaMoonUiColor
---@field accent? BetaMoonUiColor
---@field focus? BetaMoonUiColor
---@field selection? BetaMoonUiColor
---@field padding? integer Style metrics 0..256.
---@field borderWidth? integer
---@field shadow? boolean
---@field nativeButton? boolean
---@field font? string Prepared bitmap font name or 'native'.
---@field backgroundDrawable? string
---@field contentDrawable? string

---@class BetaMoonUiThemeDefinition
---@field key string
---@field base? 'menu'|'minimal'|'container_legacy' Default menu.
---@field variants? table<string, {extends: string?, values: BetaMoonUiStyle?, states: table<string, BetaMoonUiStyle>?}> State selectors use hovered/pressed/selected/focused/invalid/disabled joined with +. State overrides cannot change font/padding.
---@field templates? table<string, {parts: string[], paint: fun(view: BetaMoonUiTemplateView): BetaMoonUiPaintCommand[]|table<string, BetaMoonUiPaintCommand[]>}> Complete prepared alternatives; 'default' required. Selectors also accept caret.

---@class BetaMoonUiTemplateView
---@field kind BetaMoonUiControl
---@field width number
---@field height number
---@field props table<string, any> Control values; fraction is normalized slider/progress fill.
---@field font string
---@field styles table<string, table<string, number|boolean>> Resolved scalar styles for default and each single state.
---@field metrics {lineHeight: integer, textWidth: integer, padding: integer, stepperButtonWidth: integer?, radioOptions: BetaMoonUiRadioOptionBounds[]?, textarea: BetaMoonUiTextAreaMetrics?, caretX: integer?, selectionLeft: integer?, selectionRight: integer?}

---@class BetaMoonUiTextAreaRect
---@field x integer Control-local coordinates.
---@field y integer
---@field width integer
---@field height integer

---@class BetaMoonUiTextAreaRun
---@field text string Visible plain-text run; tabs expand to four spaces. A visual line may contain several runs.
---@field x integer Control-local coordinates.
---@field y integer

---@class BetaMoonUiTextAreaMetrics
---@field viewport BetaMoonUiTextAreaRect Clip text commands to this rectangle.
---@field caret BetaMoonUiTextAreaRect Clipped caret; zero width/height when outside the viewport.
---@field scrollX integer Accepted horizontal offset.
---@field scrollY integer Accepted vertical offset.
---@field lines BetaMoonUiTextAreaRun[] Visible text runs with scrolling already applied.
---@field selection BetaMoonUiTextAreaRect[] Clipped visible selection rectangles.

---@class BetaMoonUiActionDefinition
---@field scope 'client'|'world'|'player_data' player_data requests currently return player_data_unavailable.
---@field payload? BetaMoonUiSchema
---@field handler fun(ctx: BetaMoonUiContext, payload: table<string, any>): any Detached serializable result.

---@class BetaMoonUiScreenDefinition
---@field key string
---@field context? 'client'|'world' Default client; world requires a healthy local player and single-player world.
---@field pauseGame? boolean Default false; effective only with a world.
---@field root BetaMoonUiNode
---@field state? BetaMoonUiSchema
---@field data? BetaMoonUiSchema
---@field actions? table<string, BetaMoonUiActionDefinition>
---@field on? {open: fun(ctx: BetaMoonUiContext, event: BetaMoonUiEvent)?, refresh: fun(ctx: BetaMoonUiContext, event: BetaMoonUiEvent)?, update: fun(ctx: BetaMoonUiContext, event: BetaMoonUiEvent)?, close: fun(ctx: BetaMoonUiContext, event: BetaMoonUiEvent)?}
---@field updateInterval? integer Logical update ticks, 1..1200; default 1.
---@field theme? string Default menu.
---@field resources? BetaMoonUiResources
---@field requires? BetaMoonUiCapability[]

---@class BetaMoonUiOpenOptions
---@field state? table<string, any>
---@field data? table<string, any>

---@class BetaMoonUiActionTicket
---@field id integer
---@field status fun(self: BetaMoonUiActionTicket): 'queued'|'running'|'succeeded'|'refused'|'failed'|'cancelled'
---@field reason fun(self: BetaMoonUiActionTicket): string? origin_expired cancels intent from a failed callback or expired component lifetime.
---@field result fun(self: BetaMoonUiActionTicket): any Read-only detached completion value; nil before success.

---@class BetaMoonUiScreenInstance
---@field key string
---@field state BetaMoonUiModel Available only while active.
---@field data BetaMoonUiModel
---@field status fun(self: BetaMoonUiScreenInstance): 'queued'|'prepared'|'active'|'closed'|'failed'|'cancelled'
---@field reason fun(self: BetaMoonUiScreenInstance): string?
---@field close fun(self: BetaMoonUiScreenInstance): boolean Immediately revokes input/actions; disposal at the next boundary.
---@field back fun(self: BetaMoonUiScreenInstance): boolean Restores compatible detached history; dialogs close.
---@field push fun(self: BetaMoonUiScreenInstance, key: string, options?: BetaMoonUiOpenOptions): BetaMoonUiScreenInstance?, string?
---@field replace fun(self: BetaMoonUiScreenInstance, key: string, options?: BetaMoonUiOpenOptions): BetaMoonUiScreenInstance?, string?
---@field dialog fun(self: BetaMoonUiScreenInstance, key: string, options?: BetaMoonUiOpenOptions): BetaMoonUiScreenInstance?, string? Modal document in the same native screen.
---@field popover fun(self: BetaMoonUiScreenInstance, key: string, anchor: string, options?: BetaMoonUiOpenOptions): BetaMoonUiScreenInstance?, string? Anchored owned document; Escape/outside/Tab dismiss. Anchor is a visible local/exported element ID.
---@field request fun(self: BetaMoonUiScreenInstance, name: string, payload?: table<string, any>): BetaMoonUiActionTicket?, string? Admission failure returns nil/reason. Requests require successful callback and GUI command-batch validation.
---@field element fun(self: BetaMoonUiScreenInstance, id: string): BetaMoonGuiElementHandle Expires on compatible visual refresh.

---@class BetaMoonUiComponentInfo
---@field key string
---@field label string
---@class BetaMoonUiThemeInfo
---@field key string
---@field base string
---@field builtIn? boolean
---@class BetaMoonUiScreenInfo
---@field key string
---@field context 'client'|'world'
---@field pauseGame boolean

---@class BetaMoonUiComponents
local UiComponents = {}
---@param definition BetaMoonUiComponentDefinition
---@return BetaMoonUiComponentInfo
function UiComponents:add(definition) end
---@param key string
---@return BetaMoonUiComponentInfo? info nil when unregistered.
function UiComponents:get(key) end
---@param key string
---@return BetaMoonUiComponentInfo
function UiComponents:getRequired(key) end

---@class BetaMoonUiThemes
local UiThemes = {}
---@param definition BetaMoonUiThemeDefinition
---@return BetaMoonUiThemeInfo
function UiThemes:add(definition) end
---@param key string
---@return BetaMoonUiThemeInfo? info nil when unregistered.
function UiThemes:get(key) end
---@param key string
---@return BetaMoonUiThemeInfo
function UiThemes:getRequired(key) end

---@class BetaMoonUiScreens
local UiScreens = {}
---@param definition BetaMoonUiScreenDefinition
---@return BetaMoonUiScreenInfo
function UiScreens:add(definition) end
---@param key string
---@return BetaMoonUiScreenInfo? info nil when unregistered.
function UiScreens:get(key) end
---@param key string
---@return BetaMoonUiScreenInfo
function UiScreens:getRequired(key) end
---@param key string
---@param options? BetaMoonUiOpenOptions
---@return BetaMoonUiScreenInstance? instance Queued handle; native ownership begins only after complete preflight.
---@return string? reason Admission refusal; unknown/invalid declarations raise an error.
function UiScreens:open(key, options) end
---@return BetaMoonUiScreenInstance? instance Current root owned by the calling script.
function UiScreens:current() end

---@alias BetaMoonUiMenuTarget 'minecraft:main'|'minecraft:pause'|'minecraft:options'|'minecraft:world_select'|'betamoon:world_create'
---@class BetaMoonUiMenuDefinition
---@field key string Canonical owned contribution key.
---@field target BetaMoonUiMenuTarget Exact supported native menu.
---@field screen string Registered screen owned by this script.
---@field region? 'actions'|'footer'|'content' Defaults to actions, or content for replacements.
---@field replace? boolean Explicit replacement claim; main/pause only. Defaults to false.
---@field priority? integer Replacement priority -10000..10000; defaults to zero. Additive entries require zero.
---@field before? string[] At most 32 keys in the same target/region; additive only.
---@field after? string[] At most 32 keys in the same target/region; additive only.

---@class BetaMoonUiMenuInfo
---@field key string
---@field target BetaMoonUiMenuTarget
---@field screen string
---@field region 'actions'|'footer'|'content'
---@field replace boolean
---@field priority integer

---@class BetaMoonUiMenuActivation
---@field key string
---@field status fun(self: BetaMoonUiMenuActivation): 'queued'|'active'|'suspended'|'refused'|'closed'
---@field reason fun(self: BetaMoonUiMenuActivation): string?
---@field instance fun(self: BetaMoonUiMenuActivation): BetaMoonUiScreenInstance? Attached instance, when prepared and active.
---@field close fun(self: BetaMoonUiMenuActivation) Immediately release the claim; cleanup follows at a logical boundary.

---@class BetaMoonUiMenuContext
---@field target BetaMoonUiMenuTarget
---@field key string Contribution key.
---@field enabled fun(self: BetaMoonUiMenuContext, action: string): boolean Native button availability.
---@field action fun(self: BetaMoonUiMenuContext, action: string): BetaMoonUiActionTicket?, string? Queue a typed native action; callback/command validation must succeed.

---@class BetaMoonUiMenus
local UiMenus = {}
---@param definition BetaMoonUiMenuDefinition
---@return BetaMoonUiMenuInfo
function UiMenus:add(definition) end
---@param key string
---@return BetaMoonUiMenuInfo? info nil when unregistered.
function UiMenus:get(key) end
---@param key string
---@return BetaMoonUiMenuInfo
function UiMenus:getRequired(key) end
---Requires the BetaMoon Java agent.
---@param key string
---@return BetaMoonUiMenuActivation
function UiMenus:activate(key) end

---@class BetaMoonUiInventoryPosition
---@field x integer Panel-local item position, 1..4096; preserve the one-pixel native hit margin.
---@field y integer
---@class BetaMoonUiInventoryPreview
---@field visible? boolean Defaults to true.
---@field x? integer Defaults to 21.
---@field y? integer Defaults to 15.
---@field width? integer 1..256, defaults to 60.
---@field height? integer 1..256, defaults to 60.
---@class BetaMoonUiInventoryDefinition
---@field key string Canonical owned presentation key.
---@field screen? string Owned registered screen for content, resources and actions.
---@field priority? integer -10000..10000, defaults to zero; ties sort by key.
---@field panel? {width: integer?, height: integer?} Dimensions 36..4096; omitted dimensions retain native size.
---@field groups? table<'output'|'crafting'|'armor'|'storage'|'hotbar', BetaMoonUiInventoryPosition> Top-left item position; native 18-pixel spacing.
---@field positions? table<string, BetaMoonUiInventoryPosition> Overrides semantic IDs such as hotbar/1 or storage/27.
---@field background? 'native'|'panel'|'none' Defaults to panel; native requires original panel/slots.
---@field backgroundImage? string Prepared image/drawable resource name in screen.
---@field slotFrames? boolean Defaults to false for native background, true otherwise.
---@field craftingLabel? boolean Defaults to true.
---@field preview? BetaMoonUiInventoryPreview
---@class BetaMoonUiInventoryInfo
---@field key string
---@field priority integer
---@field screen? string
---@class BetaMoonUiInventoryActivation
---@field key string
---@field status fun(self: BetaMoonUiInventoryActivation): 'queued'|'active'|'suspended'|'refused'|'closed'
---@field reason fun(self: BetaMoonUiInventoryActivation): string?
---@field instance fun(self: BetaMoonUiInventoryActivation): BetaMoonUiScreenInstance? Nil for layout-only profiles.
---@field close fun(self: BetaMoonUiInventoryActivation) Immediately revoke eligibility; restore geometry at the next paint boundary.
---@class BetaMoonUiBounds
---@field x integer
---@field y integer
---@field width integer
---@field height integer
---@class BetaMoonUiInventorySlot: BetaMoonUiBounds
---@field id string Semantic group/index ID.
---@field group 'output'|'crafting'|'armor'|'storage'|'hotbar'
---@field index integer One-based index within its group.
---@class BetaMoonUiInventoryLayout
---@field panel BetaMoonUiBounds Global centered panel bounds.
---@field preview BetaMoonUiBounds Panel-local preview bounds; zero extent when hidden.
---@field slots BetaMoonUiInventorySlot[] Panel-local 16x16 item rectangles; native hit regions extend one pixel around them.
---@field displayed boolean Whether the current eligible presentation has a complete displayed frame.
---@class BetaMoonUiInventoryContext
---@field layout fun(self: BetaMoonUiInventoryContext): BetaMoonUiInventoryLayout Read-only detached snapshot; method expires with the callback.
---@class BetaMoonUiInventories
local UiInventories = {}
---@param definition BetaMoonUiInventoryDefinition
---@return BetaMoonUiInventoryInfo
function UiInventories:add(definition) end
---@param key string
---@return BetaMoonUiInventoryInfo? info Nil when unregistered.
function UiInventories:get(key) end
---@param key string
---@return BetaMoonUiInventoryInfo
function UiInventories:getRequired(key) end
---Requires the BetaMoon Java agent. Applies to the exact native local single-player inventory.
---@param key string
---@return BetaMoonUiInventoryActivation
function UiInventories:activate(key) end

---@alias BetaMoonUiHudPart 'crosshair'|'hotbar'|'health'|'armor'|'breath'|'chat'
---@alias BetaMoonUiHudVisibility 'gameplay'|'chat'|'inventory'|'pause'|'menu'
---@class BetaMoonUiHudNativePart
---@field hide? boolean True requests hiding; choose exactly one hide or replace.
---@field replace? string Owned registered screen key for a passive replacement.
---@class BetaMoonUiHudDefinition
---@field key string Canonical owned HUD key.
---@field screen? string Owned registered screen key for additive content.
---@field nativeParts? table<BetaMoonUiHudPart, BetaMoonUiHudNativePart> Additive content or at least one native claim is required.
---@field priority? integer -10000..10000; higher replacement priority wins, ties use latest activation.
---@field visibility? {contexts: BetaMoonUiHudVisibility[]?, debug: boolean?, hideGui: boolean?} Default gameplay, debug=true, hideGui=false.
---@field safeArea? boolean Defaults to true for additive content; reserve native/notification/recovery chrome.
---@field interactive? boolean Defaults to false; replacement documents always stay passive.
---@field regions? string[] 1..32 local/exported element IDs, required only for interactive additive content.
---@class BetaMoonUiHudInfo
---@field key string
---@field priority integer
---@field interactive boolean
---@field screen? string
---@class BetaMoonUiHudPartStatus
---@field status 'queued'|'hidden'|'replaced'|'covered'|'unavailable'|'suspended'|'failed'|'closed'
---@field reason? 'not_rendered'|'native_hook_unavailable'
---@class BetaMoonUiHudActivation
---@field key string
---@field status fun(self: BetaMoonUiHudActivation): 'queued'|'active'|'suspended'|'refused'|'closed'
---@field reason fun(self: BetaMoonUiHudActivation): string?
---@field instance fun(self: BetaMoonUiHudActivation, part?: BetaMoonUiHudPart): BetaMoonUiScreenInstance? Omit part for additive content.
---@field parts fun(self: BetaMoonUiHudActivation): table<BetaMoonUiHudPart, BetaMoonUiHudPartStatus> Read-only detached status for each requested part.
---@field inputAvailable fun(self: BetaMoonUiHudActivation): boolean Declared painted regions in a compatible native cursor host or explicit gameplay cursor mode.
---@field enterCursorMode fun(self: BetaMoonUiHudActivation): boolean, string? Explicit gameplay request; false plus reason when unavailable.
---@field leaveCursorMode fun(self: BetaMoonUiHudActivation) Release this claim's gameplay cursor token.
---@field isCursorMode fun(self: BetaMoonUiHudActivation): boolean Whether this claim owns the current gameplay cursor token.
---@field close fun(self: BetaMoonUiHudActivation) Immediately revoke the claim and its cursor; dispose presentation at the next logical boundary.
---@class BetaMoonUiHudPlayer
---@field health integer
---@field armor integer
---@field air integer
---@field selectedSlot integer One-based hotbar selection, 1..9.
---@field onGround boolean
---@field x number
---@field y number
---@field z number
---@field motionX number
---@field motionY number
---@field motionZ number
---@class BetaMoonUiHudSnapshot
---@field context BetaMoonUiHudVisibility|'unavailable'
---@field worldAvailable boolean Healthy local single-player world/player.
---@field hideGui boolean
---@field debug boolean
---@field viewport BetaMoonUiBounds Logical screen rectangle.
---@field safeArea BetaMoonUiBounds Reserved-area-aware additive rectangle.
---@field player? BetaMoonUiHudPlayer Absent without a healthy local player.
---@class BetaMoonUiHudContext
---@field key string HUD definition key.
---@field snapshot fun(self: BetaMoonUiHudContext): BetaMoonUiHudSnapshot Read-only detached values; method expires with its callback.
---@class BetaMoonUiHuds
local UiHuds = {}
---@param definition BetaMoonUiHudDefinition
---@return BetaMoonUiHudInfo
function UiHuds:add(definition) end
---@param key string
---@return BetaMoonUiHudInfo? info Nil when unregistered.
function UiHuds:get(key) end
---@param key string
---@return BetaMoonUiHudInfo
function UiHuds:getRequired(key) end
---Current native hook support; false preserves native drawing for an unsupported part.
---@return table<BetaMoonUiHudPart, boolean>
function UiHuds:capabilities() end
---Requires the BetaMoon Java agent; registration alone changes nothing.
---@param key string
---@return BetaMoonUiHudActivation
function UiHuds:activate(key) end

---@alias BetaMoonUiNotificationCorner 'top_left'|'top_right'|'bottom_left'|'bottom_right'
---@class BetaMoonUiNotificationDefinition
---@field key string Owned template key.
---@field screen string Owned registered screen; its data schema validates show/update data.
---@field width? integer 80..512, default 160; narrowed to fit a viewport column.
---@field height? integer 20..256, default 40.
---@field corner? BetaMoonUiNotificationCorner Default top_right.
---@field interactive? boolean Default false.
---@field regions? string[] 1..32 local/exported IDs, required for interactive templates.
---@class BetaMoonUiNotificationInfo
---@field key string
---@field screen string
---@field width integer
---@field height integer
---@field corner BetaMoonUiNotificationCorner
---@field interactive boolean
---@class BetaMoonUiNotificationOptions
---@field data? table<string, any> Typed screen data; updates merge a patch into the handle's detached data.
---@field duration? number 0.5..60 seconds, default 5; rounded to milliseconds.
---@field corner? BetaMoonUiNotificationCorner Overrides template/default/current corner.
---@field urgency? 'low'|'normal'|'high' Default normal; presentation metadata, without bypassing queue fairness.
---@field lifetime? 'client'|'world' Default client; immutable after showing.
---@field dedupKey? string 1..160 characters; owner/template scoped, immutable after showing.
---@field restartDuration? boolean Default true for show/dedup, false for handle update.
---@field pauseOnHover? boolean Default false; requires an available interaction host.
---@field pauseOnFocus? boolean Default false.
---@class BetaMoonUiNotification
---@field id integer
---@field key string Template key.
---@field status fun(self: BetaMoonUiNotification): 'queued'|'visible'|'exiting'|'dismissed'|'expired'|'cancelled'|'failed'
---@field reason fun(self: BetaMoonUiNotification): string?
---@field update fun(self: BetaMoonUiNotification, options?: BetaMoonUiNotificationOptions): boolean, string? Atomic typed patch; false plus reason when inactive or admission fails.
---@field dismiss fun(self: BetaMoonUiNotification) Revoke input/actions immediately; a displayed view has a short Java exit transition.
---@field instance fun(self: BetaMoonUiNotification): BetaMoonUiScreenInstance? Prepared instance, including while awaiting its first paint; nil when unavailable/exiting/terminal.
---@field inputAvailable fun(self: BetaMoonUiNotification): boolean Declared regions in a compatible native cursor host or explicit gameplay cursor mode.
---@field enterCursorMode fun(self: BetaMoonUiNotification): boolean, string? Explicit gameplay cursor request; false plus reason when unavailable.
---@field leaveCursorMode fun(self: BetaMoonUiNotification)
---@field isCursorMode fun(self: BetaMoonUiNotification): boolean
---@class BetaMoonUiNotificationSnapshot
---@field id integer
---@field key string Template key.
---@field corner BetaMoonUiNotificationCorner
---@field urgency 'low'|'normal'|'high'
---@class BetaMoonUiNotificationContext
---@field snapshot fun(self: BetaMoonUiNotificationContext): BetaMoonUiNotificationSnapshot Read-only detached metadata; method expires with the callback.
---@class BetaMoonUiNotifications
local UiNotifications = {}
---@param definition BetaMoonUiNotificationDefinition
---@return BetaMoonUiNotificationInfo
function UiNotifications:add(definition) end
---@param key string
---@return BetaMoonUiNotificationInfo? info Nil when unregistered.
function UiNotifications:get(key) end
---@param key string
---@return BetaMoonUiNotificationInfo
function UiNotifications:getRequired(key) end
---Requires the BetaMoon Java agent and a ready client update boundary. A queued handle is not yet visible.
---@param key string
---@param options? BetaMoonUiNotificationOptions
---@return BetaMoonUiNotification? notification Same live handle ID for matching owner/template/dedup key.
---@return string? reason Explicit client/world/queue/data/template refusal.
function UiNotifications:show(key, options) end

---@class BetaMoonClientUi
---@field components BetaMoonUiComponents
---@field themes BetaMoonUiThemes
---@field screens BetaMoonUiScreens
---@field menus BetaMoonUiMenus
---@field inventories BetaMoonUiInventories
---@field huds BetaMoonUiHuds
---@field notifications BetaMoonUiNotifications
local ClientUi = {components = UiComponents, themes = UiThemes, screens = UiScreens, menus = UiMenus, inventories = UiInventories, huds = UiHuds, notifications = UiNotifications}

---@alias BetaMoonUiExpression number|{source: 'width'|'height'|'property', property: string?, factor: number?, offset: number?} Affine reference; property must be declared numeric.
---@class BetaMoonUiPaintView
---@field width number
---@field height number
---@field props table<string, any>
---@field state BetaMoonGuiReadAccess
---@field data BetaMoonGuiDataReadAccess
---@field inventory? BetaMoonUiInventoryContext Scoped inventory layout when provided by the host.
---@field hud? BetaMoonUiHudContext Scoped HUD observation when provided by the host.
---@field notification? BetaMoonUiNotificationContext Scoped notification metadata when provided by the host.

---@class BetaMoonUiPaintCommand
---@field op 'rect'|'line'|'mesh'|'ring'|'text'|'image'|'pushTransform'|'popTransform'|'pushClip'|'popClip'|'hitRect'|'hitCircle'|'hitPolygon'
---@field x? BetaMoonUiExpression
---@field y? BetaMoonUiExpression
---@field width? BetaMoonUiExpression
---@field height? BetaMoonUiExpression
---@field color? BetaMoonUiColor Default white.
---@field x1? BetaMoonUiExpression
---@field y1? BetaMoonUiExpression
---@field x2? BetaMoonUiExpression
---@field y2? BetaMoonUiExpression
---@field inner? BetaMoonUiExpression
---@field outer? BetaMoonUiExpression
---@field start? BetaMoonUiExpression Degrees; default 0.
---@field sweep? BetaMoonUiExpression Default 360.
---@field segments? integer 3..512; default 64.
---@field mode? 'triangles'|'lines'|'quads'
---@field vertices? number[] Flat x,y pairs; simple polygon for hitPolygon.
---@field text? string
---@field font? string Default native.
---@field shadow? boolean Default true.
---@field image? string Prepared image/drawable name.
---@field scaleX? BetaMoonUiExpression
---@field scaleY? BetaMoonUiExpression
---@field rotation? BetaMoonUiExpression Degrees.
---@field name? string Named hit region.
---@field radius? BetaMoonUiExpression

---@class BetaMoonUiResources
---@field images? table<string, {source: BetaMoonTextureInput, nearest: boolean?}> Whole texture images only.
---@field meshes? table<string, {mode: 'triangles'|'lines'|'quads'?, vertices: number[]}>
---@field buffers? table<string, {mode: 'triangles'|'lines'|'quads'?, stride: integer?, vertices: number[]}> Stride 2 (xy) or 4 (xyuv).
---@field programs? table<string, {vertex: string, fragment: string, uniforms: table<string, integer>?}> Uniform sizes 1..4, -1 integer, or 16 column-major matrix.
---@field targets? table<string, {width: integer, height: integer, depth: boolean?}> At most 4194304 pixels; each axis <=4096.
---@field drawables? table<string, {image: string?, color: BetaMoonUiColor?, x: integer?, y: integer?, width: integer?, height: integer?, border: integer?}> Exactly one image/color; border selects nine-slice.
---@field fonts? table<string, {image: string, lineHeight: integer, fallback: integer|string, glyphs: BetaMoonUiGlyph[]}>

---@class BetaMoonUiGlyph
---@field codepoint integer|string
---@field x? integer
---@field y? integer
---@field width? integer
---@field height? integer
---@field advance integer
---@field offsetX? integer
---@field offsetY? integer

---@class BetaMoonUiRawFrame
---@field gl BetaMoonUiRawGraphics Expires when rawDraw returns.
---@field native BetaMoonNativeAccess Read-only; no gameplay/UI/action authority.
---@field props table<string, any>
---@field data table<string, any> Detached published root data.
---@field bounds {x: number, y: number, width: number, height: number} Element-local bounds.
---@field viewport {width: integer, height: integer, framebufferWidth: integer, framebufferHeight: integer}
---@field clip {left: number, top: number, right: number, bottom: number, pixelX: integer, pixelY: integer, pixelWidth: integer, pixelHeight: integer}
---@field transform {x: number, y: number, scaleX: number, scaleY: number}
---@field inverse {x: number, y: number, scaleX: number, scaleY: number}
---@field time number Seconds since contribution creation.
---@field delta number Seconds since previous raw callback.
---@field partialTick number
---@field opacity number

---@class BetaMoonUiRawGraphics
---@field color fun(self: BetaMoonUiRawGraphics, color: integer)
---@field mesh fun(self: BetaMoonUiRawGraphics, name: string, color?: integer)
---@field buffer fun(self: BetaMoonUiRawGraphics, name: string)
---@field vertices fun(self: BetaMoonUiRawGraphics, mode: 'triangles'|'lines'|'quads', vertices: number[], color?: integer)
---@field texture fun(self: BetaMoonUiRawGraphics, unit: integer, name?: string)
---@field program fun(self: BetaMoonUiRawGraphics, name?: string)
---@field uniform fun(self: BetaMoonUiRawGraphics, name: string, ...: number) Declared float vector size 1..4.
---@field uniformInt fun(self: BetaMoonUiRawGraphics, name: string, value: integer)
---@field uniformMatrix fun(self: BetaMoonUiRawGraphics, name: string, values: number[]) 16 column-major values.
---@field target fun(self: BetaMoonUiRawGraphics, name?: string) nil restores the host framebuffer and clip.
---@field clear fun(self: BetaMoonUiRawGraphics, color?: integer, depth?: boolean)
---@field enable fun(self: BetaMoonUiRawGraphics, capability: string, enabled: boolean)
---@field blend fun(self: BetaMoonUiRawGraphics, source: string, destination: string)
---@field push fun(self: BetaMoonUiRawGraphics)
---@field pop fun(self: BetaMoonUiRawGraphics)
---@field translate fun(self: BetaMoonUiRawGraphics, x: number, y: number, z?: number)
---@field scale fun(self: BetaMoonUiRawGraphics, x: number, y: number, z?: number)
---@field rotate fun(self: BetaMoonUiRawGraphics, degrees: number)
---@field ortho fun(self: BetaMoonUiRawGraphics, left: number, right: number, bottom: number, top: number, near?: number, far?: number)

return {
    ClientUi = ClientUi
}
