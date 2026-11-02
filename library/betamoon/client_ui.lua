---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: CLIENT UI
-- --------------------------------------------------------------------------

---@alias BetaMoonUiColor integer|string ARGB integer or #RRGGBB/#AARRGGBB.
---@alias BetaMoonUiCapability 'input'|'modal_layers'|'world_data'|'native_inventory'|'native_items'|'prepared_drawing'|'raw_drawing'
---@alias BetaMoonUiControl 'text'|'image'|'panel'|'row'|'column'|'grid'|'scroll'|'list'|'tree'|'table'|'overlay'|'spacer'|'divider'|'button'|'checkbox'|'choice'|'radio'|'slider'|'stepper'|'textbox'|'textarea'|'progress'|'dialog'|'tooltip'
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

---@class BetaMoonUiContext
---@field native BetaMoonNativeAccess Read-only native entry except in a declared action's explicit action scope.
---@field screen BetaMoonUiScreenInstance
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
---@field selectedKey? string List/tree/table/radio: selected key; empty string clears selection. Bound values require acknowledgement.
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
---@field text? string Text, button, checkbox, choice, stepper prefix, textbox, textarea, dialog, tooltip.
---@field image? string Prepared image/drawable name.
---@field selected? boolean Checkbox value.
---@field value? number Slider/stepper/progress value, or 1-based choice index. Stepper values snap to decimal steps.
---@field options? string[]|BetaMoonUiSelectionOption[] Choice labels, or 0..256 keyed radio options.
---@field minimum? number Slider/stepper/progress minimum; default 0.
---@field maximum? number Slider/stepper/progress maximum; default 100.
---@field step? number Slider/stepper step; default 1. Stepper accepts 0.000001..1000000000000.
---@field orientation? 'horizontal'|'vertical' Slider/progress default horizontal; radio defaults vertical.
---@field optionHeight? integer Radio option height 1..1024, default 20.
---@field maximumLength? integer Textbox/textarea UTF-16 limit 0..65536; default 4096. Textarea normalizes CRLF/CR to LF before checking.
---@field wrap? boolean Textarea: wrap to viewport width (default true); false allows horizontal scrolling.
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

---@class BetaMoonClientUi
---@field components BetaMoonUiComponents
---@field themes BetaMoonUiThemes
---@field screens BetaMoonUiScreens
local ClientUi = {components = UiComponents, themes = UiThemes, screens = UiScreens}

---@alias BetaMoonUiExpression number|{source: 'width'|'height'|'property', property: string?, factor: number?, offset: number?} Affine reference; property must be declared numeric.
---@class BetaMoonUiPaintView
---@field width number
---@field height number
---@field props table<string, any>
---@field state BetaMoonGuiReadAccess
---@field data BetaMoonGuiDataReadAccess

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
