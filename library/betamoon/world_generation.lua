---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: WORLD GENERATION
-- --------------------------------------------------------------------------

---@class BetaMoonOreDefinition
---@field displayName? string Optional generation-settings label; falls back to the canonical key.
---@field key? string Stable placement key. Omit only for private compatibility registrations.
---@field block BetaMoonBlockReference|integer
---@field veinsPerChunk integer
---@field veinSize integer
---@field height {min: integer, max: integer}
---@field dimension? BetaMoonDimensionSelection Omitted preserves native defaults; both/all are native-only aliases.
---@field replace BetaMoonBlockReference|integer|nil
---@field biomes BetaMoonBiomeName[]|nil
---@field salt? integer Additional stable seed salt.

---@class BetaMoonOreReference: BetaMoonWorldPlacementReference
---@field id integer
---@field key string Stable placement key, including generated private keys.
---@field owner string
---@field exists boolean
---@field enabled boolean
---@field block integer
---@field veinsPerChunk integer
---@field veinSize integer
---@field height {min: integer, max: integer}
---@field dimension BetaMoonDimensionSelection
---@field replace integer|nil
---@field biomes string[]
---@field override fun(self: BetaMoonOreReference, definition: table): BetaMoonOverrideHandle

---@class BetaMoonOreQuery
---@field key? string
---@field owner? string
---@field enabled? boolean
---@field block? BetaMoonBlockReference|integer
---@field dimension? BetaMoonDimensionSelection

---@alias BetaMoonWorldFeatureSelector string|BetaMoonWorldFeatureReference
---@alias BetaMoonWorldPlacementSelector string|BetaMoonWorldPlacementReference
---@alias BetaMoonWorldGenerationStage 'underground_structures'|'underground_features'|'surface_structures'|'surface_features'|'vegetation'|'entities'|'post_process'

---@class BetaMoonWorldFeatureResult
---@field placed boolean
---@field reason? 'blocked'|'out_of_bounds'|'unloaded_chunk'|'invalid_ground'|'protected'|'budget_exceeded'|'no_changes'|'runtime_error'|'terrain_unreadable'|'terrain_slope'|'terrain_step'|'terrain_support'|'terrain_mutation_budget'|'foundation_invalid_footprint'|'foundation_too_deep'|'foundation_protected_block'|'foundation_tile_collision'|'foundation_fluid_collision'|'terrace_invalid_footprint'|'terrace_cut_limit'|'terrace_fill_limit'|'terrace_grade_limit'|'terrace_protected_block'|'terrace_tile_collision'|'terrace_fluid_collision'|'excavation_invalid_volume'|'excavation_too_large'|'excavation_unreadable'|'excavation_protected_block'|'excavation_tile_collision'|'excavation_fluid_collision'|'site_wrong_surface_relation'|'site_wrong_medium'|'site_fluid_coverage'|'site_fluid_depth'|'site_depth'|'site_insufficient_cover'|'site_insufficient_cavity'|'site_sky_mismatch'|'conform_path_failed'|'conform_empty_selection'|'conform_unknown_mask'|'conform_selector_invalid'|'conform_displacement_limit'|'conform_step_limit'|'conform_column_collision'|'loot_target_missing'|'loot_inventory_size'|'loot_existing_contents'|'loot_overflow'|'loot_mutation_failed'
---@field blocksChanged integer
---@field bounds? {min: BetaMoonPositionI, max: BetaMoonPositionI}
---@field details? BetaMoonWorldFeatureDetails Structure terrain and site diagnostics when applicable.

---@class BetaMoonWorldFeatureDetails
---@field terrainMode? string
---@field terrainSurface? string
---@field siteType? string
---@field supportColumns? integer
---@field requestedAnchorY? integer
---@field resolvedAnchorY? integer
---@field sampledMinimumY? integer
---@field sampledMaximumY? integer
---@field supportRatio? number
---@field fluidCoverage? number
---@field existingAirRatio? number
---@field terrainBlocksPlanned? integer
---@field terrainWritesPlanned? integer
---@field excavationVolumeCells? integer
---@field excavationRemoved? integer
---@field excavationPreserved? integer
---@field excavationAdaptationOverlaps? integer
---@field foundationCoreCells? integer
---@field foundationCoreWrites? integer
---@field foundationEdgeWrites? integer
---@field foundationMaximumDepth? integer
---@field foundationBounds? string
---@field terraceCoreCells? integer
---@field terraceTransitionCells? integer
---@field terraceCutBlocks? integer
---@field terraceFillBlocks? integer
---@field terraceBounds? string
---@field conformSource? string
---@field conformSupportColumns? integer
---@field conformSelectedColumns? integer
---@field conformComponents? integer
---@field conformMinimumDisplacement? integer
---@field conformMaximumDisplacement? integer
---@field terrainStructureOverlaps? integer
---@field structureWritesPlanned? integer
---@field totalWritesPlanned? integer
---@field terrainRejectedPosition? string

---@class BetaMoonWorldFeaturePlaceOptions
---@field seed? integer Extra deterministic seed salt.
---@field rotation? 'none'|'clockwise_90'|'clockwise_180'|'counterclockwise_90'|'random'|'random_horizontal' Structure rotation override.
---@field mirror? 'none'|'left_right'|'front_back'|'random' Structure mirror override.

---@class BetaMoonWorldFeatureReference
---@field displayName string Presentation label or canonical key.
local WorldFeatureReference = {}
---@return string
function WorldFeatureReference:getKey() return '' end
---@param world BetaMoonActionWorld
---@param x integer
---@param y integer
---@param z integer
---@param options? BetaMoonWorldFeaturePlaceOptions
---@return BetaMoonWorldFeatureResult
---@overload fun(self: BetaMoonWorldFeatureReference, world: BetaMoonActionWorld, position: BetaMoonCellPosition, options?: BetaMoonWorldFeaturePlaceOptions): BetaMoonWorldFeatureResult
function WorldFeatureReference:place(world, x, y, z, options) return {} end
---@param world BetaMoonActionWorld
---@param x integer
---@param y integer
---@param z integer
---@param options? BetaMoonWorldFeaturePlaceOptions
---@return BetaMoonWorldFeatureResult
---@overload fun(self: BetaMoonWorldFeatureReference, world: BetaMoonActionWorld, position: BetaMoonCellPosition, options?: BetaMoonWorldFeaturePlaceOptions): BetaMoonWorldFeatureResult
function WorldFeatureReference:preview(world, x, y, z, options) return {} end

---@class BetaMoonWorldPlacementReference
---@field displayName string Presentation label or canonical key.
local WorldPlacementReference = {}
---@return string
function WorldPlacementReference:getKey() return '' end
---@return BetaMoonWorldFeatureReference
function WorldPlacementReference:getFeature() return WorldFeatureReference end
---@param world BetaMoonActionWorld
---@param x integer
---@param z integer
---@param maxChunks? integer Search radius in chunks, from 0 to 128. Defaults to 32.
---@return BetaMoonWorldPlacementCandidate|nil
---@overload fun(self: BetaMoonWorldPlacementReference, world: BetaMoonActionWorld, position: BetaMoonXZPosition, maxChunks?: integer): BetaMoonWorldPlacementCandidate|nil
function WorldPlacementReference:locateCandidate(world, x, z, maxChunks) end

---@class BetaMoonWorldPlacementCandidate
---@field x integer Block X at the candidate chunk center.
---@field z integer Block Z at the candidate chunk center.
---@field chunkX integer Candidate chunk X.
---@field chunkZ integer Candidate chunk Z.
---@field loaded boolean Whether the candidate chunk is currently loaded; this does not prove placement succeeded.

---@class BetaMoonWorldFeatureBase
---@field displayName? string Optional generation-settings label; falls back to the canonical key.
---@field tags? string[] Namespaced generation tags.
---@field key string
---@field type 'ore_vein'|'block_patch'|'column'|'disk'|'weighted'|'sequence'|'no_op'
---@field block? BetaMoonBlockReference|integer|string
---@field metadata? integer
---@field replace? (BetaMoonBlockReference|integer|string)[]|BetaMoonBlockReference|integer|string
---@field size? integer Ore vein size.
---@field radius? integer|{min: integer, max: integer}
---@field tries? integer Patch placement attempts.
---@field height? integer|{min: integer, max: integer} Column height.
---@field direction? 'up'|'down'
---@field halfHeight? integer Disk half-height.
---@field features? BetaMoonWorldFeatureSelector[]|{feature: BetaMoonWorldFeatureSelector, weight: integer}[]
---@field maxBlocks? integer Composite feature block budget, maximum 8192.
---@field maxRadius? integer Composite feature radius, maximum 32.

---@class BetaMoonWorldFeatureRegistry
local WorldFeatures = {}
---@param definition BetaMoonWorldFeatureBase
---@return BetaMoonWorldFeatureReference
function WorldFeatures:add(definition) return WorldFeatureReference end
---@param key string
---@return BetaMoonWorldFeatureReference|nil
function WorldFeatures:get(key) end
---@param key string
---@return BetaMoonWorldFeatureReference
function WorldFeatures:getRequired(key) return WorldFeatureReference end

---@class BetaMoonTreeTrunkDefinition
---@field block BetaMoonBlockReference|integer|string
---@field metadata? integer
---@field height integer|{min: integer, max: integer}
---@field radius? integer One or two blocks.
---@field bend? number Chance to bend each trunk level, from 0 through 1.

---@class BetaMoonTreeBranchDefinition
---@field start? number Fraction of trunk height where branches may start.
---@field count integer|{min: integer, max: integer}
---@field length integer|{min: integer, max: integer}
---@field upwardBias? number From 0 through 1.

---@class BetaMoonTreeCanopyDefinition
---@field block BetaMoonBlockReference|integer|string
---@field metadata? integer
---@field shape 'sphere'|'layered_disk'|'cone'|'clustered_sphere'
---@field radius integer|{min: integer, max: integer}
---@field density? number From 0.05 through 1.

---@class BetaMoonProceduralTreeDefinition
---@field displayName? string Optional generation-settings label; falls back to the canonical key.
---@field key string
---@field trunk BetaMoonTreeTrunkDefinition
---@field branches? BetaMoonTreeBranchDefinition
---@field canopy BetaMoonTreeCanopyDefinition
---@field ground? (BetaMoonBlockReference|integer|string)[]
---@field replace? (BetaMoonBlockReference|integer|string)[]

---@class BetaMoonVanillaTreeDefinition
---@field displayName? string Optional generation-settings label; falls back to the canonical key.
---@field key string
---@field generator 'normal'|'big'|'taiga'|'minecraft:normal'|'minecraft:big'|'minecraft:taiga'
---@field trunk? BetaMoonBlockReference|integer|string
---@field trunkMetadata? integer
---@field leaves? BetaMoonBlockReference|integer|string
---@field leavesMetadata? integer
---@field ground? (BetaMoonBlockReference|integer|string)[]
---@field replace? (BetaMoonBlockReference|integer|string)[]

---@class BetaMoonStructureTreeTemplate
---@field structure BetaMoonWorldFeatureSelector
---@field weight? integer

---@class BetaMoonStructureTreeDefinition
---@field displayName? string Optional generation-settings label; falls back to the canonical key.
---@field key string
---@field templates BetaMoonStructureTreeTemplate[]
---@field rotation? 'none'|'clockwise_90'|'clockwise_180'|'counterclockwise_90'|'random'|'random_horizontal'
---@field mirror? 'none'|'left_right'|'front_back'|'random'
---@field ground? (BetaMoonBlockReference|integer|string)[]

---@alias BetaMoonTreeDefinition BetaMoonProceduralTreeDefinition|BetaMoonVanillaTreeDefinition|BetaMoonStructureTreeDefinition

---@class BetaMoonTreeRegistry
local WorldTrees = {}
---@param definition BetaMoonTreeDefinition
---@return BetaMoonWorldFeatureReference
function WorldTrees:add(definition) return WorldFeatureReference end
---@param key string
---@return BetaMoonWorldFeatureReference|nil
function WorldTrees:get(key) end
---@param key string
---@return BetaMoonWorldFeatureReference
function WorldTrees:getRequired(key) return WorldFeatureReference end

---@alias BetaMoonStructureVector integer[] Three signed integers in x, y, z order.
---@alias BetaMoonStructureFace 'down'|'up'|'north'|'south'|'west'|'east'
---@alias BetaMoonStructureWrite 'error'|'replace'

---@class BetaMoonStructureBounds
---@field min BetaMoonStructureVector Inclusive minimum coordinate.
---@field max BetaMoonStructureVector Inclusive maximum coordinate.

---@class BetaMoonStructurePaletteVariant
---@field block integer|string Numeric block ID or registered lookup name.
---@field meta? integer Block metadata from 0 through 15.
---@field data? table Tile data copied into placed tile entities.
---@field weight? integer Positive selection weight; defaults to 1.

---@class BetaMoonStructurePaletteState
---@field block? integer|string Numeric block ID or registered lookup name; required unless variants is present.
---@field meta? integer Block metadata from 0 through 15.
---@field data? table Tile data copied into placed tile entities.
---@field variants? BetaMoonStructurePaletteVariant[] Weighted alternatives; cannot be combined with block, meta, or data.
---@field tags? string[] Semantic tags used by selectors and protection rules.

---Element tables require `type` when written directly; the matching builder helper supplies it automatically.
---@class BetaMoonStructureElementBase

---@class BetaMoonStructureBlockElement: BetaMoonStructureElementBase
---@field type? 'block' Supplied automatically by the matching builder helper.
---@field pos BetaMoonStructureVector
---@field state string Named palette state.
---@field tags? string[]
---@field write? BetaMoonStructureWrite

---@class BetaMoonStructureBoxElement: BetaMoonStructureElementBase
---@field from BetaMoonStructureVector Inclusive first corner.
---@field to BetaMoonStructureVector Inclusive opposite corner.
---@field state string Named palette state.
---@field tags? string[]
---@field write? BetaMoonStructureWrite

---@class BetaMoonStructureFillElement: BetaMoonStructureBoxElement
---@field type? 'fill' Supplied automatically by the matching builder helper.

---@class BetaMoonStructureShellElement: BetaMoonStructureBoxElement
---@field type? 'shell' Supplied automatically by the matching builder helper.
---@field thickness? integer Defaults to 1.
---@field faces? BetaMoonStructureFace[] Faces to emit; defaults to every face.

---@class BetaMoonStructureFrameElement: BetaMoonStructureBoxElement
---@field type? 'frame' Supplied automatically by the matching builder helper.
---@field thickness? integer Defaults to 1.

---@class BetaMoonStructureLineElement: BetaMoonStructureBoxElement
---@field type? 'line' Supplied automatically by the matching builder helper.

---@class BetaMoonStructureStaircaseElement: BetaMoonStructureBoxElement
---@field type? 'staircase' Supplied automatically by the matching builder helper.
---@field width? integer Defaults to 1.
---@field facing? 'north'|'east'|'south'|'west' Treat directional state metadata as authored facing north and rotate it to this facing.

---@class BetaMoonStructureCylinderElement: BetaMoonStructureElementBase
---@field type? 'cylinder' Supplied automatically by the matching builder helper.
---@field base BetaMoonStructureVector
---@field radius integer|integer[] One radius or two cross-section radii.
---@field height integer
---@field axis? 'x'|'y'|'z' Defaults to y.
---@field mode? 'solid'|'shell' Defaults to solid.
---@field thickness? integer Shell and cap thickness; defaults to 1.
---@field caps? ('top'|'bottom')[]
---@field state string
---@field tags? string[]
---@field write? BetaMoonStructureWrite

---@class BetaMoonStructureEllipsoidElement: BetaMoonStructureElementBase
---@field type? 'ellipsoid' Supplied automatically by the matching builder helper.
---@field center BetaMoonStructureVector
---@field radius integer|integer[] One radius or three axis radii.
---@field mode? 'solid'|'shell' Defaults to solid.
---@field thickness? integer Defaults to 1.
---@field state string
---@field tags? string[]
---@field write? BetaMoonStructureWrite

---@class BetaMoonStructureVoxelMapElement: BetaMoonStructureElementBase
---@field type? 'voxel_map' Supplied automatically by the matching builder helper.
---@field at BetaMoonStructureVector
---@field legend table<string, string|nil> Maps one ASCII character to a named palette state or nil.
---@field layers string[][] Y layers containing Z rows and X characters.
---@field tags? string[]
---@field write? BetaMoonStructureWrite

---@class BetaMoonStructureClearElement: BetaMoonStructureElementBase
---@field type? 'clear' Supplied automatically by the matching builder helper.
---@field from BetaMoonStructureVector
---@field to BetaMoonStructureVector

---@class BetaMoonStructureReplaceStateElement: BetaMoonStructureElementBase
---@field type? 'replace_state' Supplied automatically by the matching builder helper.
---@field from BetaMoonStructureVector
---@field to BetaMoonStructureVector
---@field replace string[] Named palette states to replace.
---@field with string Named replacement palette state.

---@class BetaMoonStructureTemplateElement: BetaMoonStructureElementBase
---@field type? 'template' Supplied automatically by the matching builder helper.
---@field name string Local template name.
---@field at? BetaMoonStructureVector Defaults to the origin.
---@field rotation? 'none'|'clockwise_90'|'clockwise_180'|'counterclockwise_90'
---@field mirror? 'none'|'left_right'|'front_back'
---@field states? table<string, string> Palette-state remapping for this instance.

---@class BetaMoonStructureArrayElement: BetaMoonStructureElementBase
---@field type? 'array' Supplied automatically by the matching builder helper.
---@field template string Local template name.
---@field at? BetaMoonStructureVector Defaults to the origin.
---@field count BetaMoonStructureVector Positive instance counts for x, y, z.
---@field step BetaMoonStructureVector Per-axis instance spacing.
---@field rotation? 'none'|'clockwise_90'|'clockwise_180'|'counterclockwise_90'
---@field mirror? 'none'|'left_right'|'front_back'
---@field states? table<string, string>

---@class BetaMoonStructureRepeatElement: BetaMoonStructureElementBase
---@field type? 'repeat' Supplied automatically by the matching builder helper.
---@field count integer
---@field step BetaMoonStructureVector
---@field element BetaMoonStructureElement

---@class BetaMoonLootIntegerRange
---@field min integer Inclusive minimum.
---@field max integer Inclusive maximum.

---@class BetaMoonExactItemStack
---@field item integer|string Numeric item/block-item ID or supported Minecraft item name. String namespaces are not registry identity; prefer numeric IDs when names could collide.
---@field count? integer Exact stack count; defaults to 1.
---@field damage? integer Exact durability or subtype metadata; defaults to 0.

---@class BetaMoonLootStackTemplate
---@field item integer|string Numeric item/block-item ID or supported Minecraft item name. String namespaces are not registry identity; prefer numeric IDs when names could collide.
---@field count? integer|BetaMoonLootIntegerRange Stack count or inclusive random range; defaults to 1.
---@field damage? integer|BetaMoonLootIntegerRange Damage metadata or inclusive random range; defaults to 0.

---@class BetaMoonLootItemEntry
---@field type 'item'
---@field weight? integer Positive selection weight; defaults to 1.
---@field stack BetaMoonLootStackTemplate

---@class BetaMoonLootEmptyEntry
---@field type 'empty'
---@field weight? integer Positive selection weight; defaults to 1.

---@class BetaMoonLootTableEntry
---@field type 'table'
---@field weight? integer Positive selection weight; defaults to 1.
---@field table string|BetaMoonLootTableReference Referenced registered loot-table key or Lua handle.

---@alias BetaMoonLootEntry BetaMoonLootItemEntry|BetaMoonLootEmptyEntry|BetaMoonLootTableEntry

---@class BetaMoonLootPool
---@field when? {spatial: BetaMoonSpatialSelector} A missing location or failed condition emits nothing.
---@field key string Stable pool key unique within this table.
---@field rolls? integer|BetaMoonLootIntegerRange Number of weighted selections; defaults to 1.
---@field entries BetaMoonLootEntry[]

---@class BetaMoonGameplayLootSource
---@field pools? BetaMoonLootPool[] Inline random table; mutually exclusive with table.
---@field table? string|BetaMoonLootTableReference Registered JSON or Lua loot table; mutually exclusive with pools.

---@alias BetaMoonBlockDrops BetaMoonBlockDrop[]|BetaMoonGameplayLootSource
---@alias BetaMoonEntityDrops BetaMoonEntityDrop[]|BetaMoonGameplayLootSource

---@class BetaMoonStructureFixedLootItem
---@field slot integer Zero-based destination inventory slot.
---@field stack BetaMoonExactItemStack

---@class BetaMoonStructureLootElement: BetaMoonStructureElementBase
---@field type? 'loot' Supplied automatically by the matching builder helper.
---@field pos BetaMoonStructureVector Target inventory coordinate.
---@field key? string Required for randomized pools or table references; omitted for fixed items.
---@field items? BetaMoonStructureFixedLootItem[] Exact stacks in exact slots; mutually exclusive with pools and table.
---@field pools? BetaMoonLootPool[] Inline random table; mutually exclusive with items and table.
---@field table? string|BetaMoonLootTableReference Reusable table reference; mutually exclusive with items and pools.
---@field slots? 'random_empty'|'ordered_empty'|integer[] Random-loot slot policy; defaults to random_empty.
---@field existing? 'require_empty'|'preserve'|'replace' Existing-content policy; defaults to require_empty.
---@field overflow? 'discard'|'reject' Random-loot overflow policy; defaults to discard.

---@class BetaMoonStructureMarkerElement: BetaMoonStructureElementBase
---@field type? 'marker' Supplied automatically by the matching builder helper.
---@field pos BetaMoonStructureVector
---@field name string
---@field value? any JSON-compatible marker value.

---@class BetaMoonStructureChanceElement: BetaMoonStructureElementBase
---@field type? 'chance' Supplied automatically by the matching builder helper.
---@field key string Stable random-stream key unique within the expanded template instance.
---@field chance number Probability from 0 through 1.
---@field elements BetaMoonStructureElement[]

---@class BetaMoonStructureChoiceEntry
---@field weight? integer Positive selection weight; defaults to 1.
---@field elements BetaMoonStructureElement[]

---@class BetaMoonStructureChoiceElement: BetaMoonStructureElementBase
---@field type? 'choice' Supplied automatically by the matching builder helper.
---@field key string Stable random-stream key unique within the expanded template instance.
---@field choices BetaMoonStructureChoiceEntry[]

---@alias BetaMoonStructureElement BetaMoonStructureBlockElement|BetaMoonStructureFillElement|BetaMoonStructureShellElement|BetaMoonStructureFrameElement|BetaMoonStructureLineElement|BetaMoonStructureStaircaseElement|BetaMoonStructureCylinderElement|BetaMoonStructureEllipsoidElement|BetaMoonStructureVoxelMapElement|BetaMoonStructureClearElement|BetaMoonStructureReplaceStateElement|BetaMoonStructureTemplateElement|BetaMoonStructureArrayElement|BetaMoonStructureRepeatElement|BetaMoonStructureLootElement|BetaMoonStructureMarkerElement|BetaMoonStructureChanceElement|BetaMoonStructureChoiceElement

---@class BetaMoonStructureLocalTemplate
---@field elements BetaMoonStructureElement[]

---@class BetaMoonStructureMarkerDistance
---@field name string
---@field distance? integer Manhattan distance from 0 through 32; defaults to 1.
---@field value? any Optional exact marker-value match.

---@class BetaMoonStructureSelector
---@field states? string[] Included named palette states.
---@field excludeStates? string[] Excluded named palette states.
---@field tags? string[] Included effective tags.
---@field match? 'any'|'all' How included tags are matched; defaults to any.
---@field excludeTags? string[]
---@field bounds? BetaMoonStructureBounds
---@field height? {min: integer?, max: integer?}
---@field faces? BetaMoonStructureFace[] Require at least one selected face to be exposed; deposit uses these as target directions.
---@field exposed? boolean
---@field minExposedFaces? integer
---@field maxExposedFaces? integer
---@field nearMarker? BetaMoonStructureMarkerDistance
---@field excludeMarkers? string[]

---@class BetaMoonStructureNoisePattern
---@field type 'noise'
---@field scale? integer Noise-cell size from 1 through 32; defaults to 3.
---@field threshold? number Selection threshold from 0 through 1; defaults to 0.5.

---@class BetaMoonStructureClusterPattern
---@field type 'clusters'
---@field radius? integer Cluster radius from 1 through 16; defaults to 2.
---@field density? number Seed-cell density from 0 through 1; defaults to 0.2.
---@field falloff? number Edge falloff from 0 through 1; defaults to 0.65.

---@alias BetaMoonStructurePattern {type: 'independent'}|BetaMoonStructureNoisePattern|BetaMoonStructureClusterPattern

---@class BetaMoonStructureWeightedState
---@field state string
---@field weight? integer Positive selection weight; defaults to 1.

---@class BetaMoonStructureDocumentProcessor
---@field type 'recolor'|'replace'|'decay'|'erode'|'deposit'
---@field key string Stable random-stream key.
---@field select? BetaMoonStructureSelector
---@field chance? number Probability from 0 through 1; defaults to 1 where supported.
---@field pattern? BetaMoonStructurePattern
---@field with? string|BetaMoonStructureWeightedState[] Required by replace and deposit; recolor accepts a single state.
---@field map? table<string, string> Recolor mapping; mutually exclusive with with.
---@field iterations? integer Erosion passes from 1 through 16.
---@field distance? integer Deposit distance from 1 through 8.
---@field onConflict? 'skip'|'error'|'replace' Deposit collision behavior; defaults to skip.
---@field allowProtected? boolean Permit changes to tagged or automatically protected cells, including tile entities, tile-data and loot targets, connectors, and terrain supports.

---@class BetaMoonStructureDocument
---@field format? 'betamoon_structure' Automatically supplied for Lua tables and builders.
---@field bounds? BetaMoonStructureBounds Optional conservative bounds containing the origin and all possible output.
---@field palette table<string, BetaMoonStructurePaletteState>
---@field templates? table<string, BetaMoonStructureLocalTemplate>
---@field elements BetaMoonStructureElement[]
---@field processors? BetaMoonStructureDocumentProcessor[] Ordered deterministic processor pipeline.

---@class BetaMoonCompiledStructure Immutable compiled structure handle.
local CompiledStructure = {}

---@class BetaMoonStructureBuilder: BetaMoonStructureDocument
local StructureBuilder = {}
---@param name string
---@param definition BetaMoonStructurePaletteState
---@return BetaMoonStructureBuilder self
function StructureBuilder:state(name, definition) return self end
---@param definition BetaMoonStructureBlockElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:block(definition) return self end
---@param definition BetaMoonStructureFillElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:fill(definition) return self end
---@param definition BetaMoonStructureShellElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:shell(definition) return self end
---@param definition BetaMoonStructureFrameElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:frame(definition) return self end
---@param definition BetaMoonStructureLineElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:line(definition) return self end
---@param definition BetaMoonStructureStaircaseElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:staircase(definition) return self end
---@param definition BetaMoonStructureCylinderElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:cylinder(definition) return self end
---@param definition BetaMoonStructureEllipsoidElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:ellipsoid(definition) return self end
---@param definition BetaMoonStructureVoxelMapElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:voxelMap(definition) return self end
---@param definition BetaMoonStructureClearElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:clear(definition) return self end
---@param definition BetaMoonStructureReplaceStateElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:replaceState(definition) return self end
---@param definition BetaMoonStructureTemplateElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:template(definition) return self end
---@param definition BetaMoonStructureTemplateElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:use(definition) return self end
---@param definition BetaMoonStructureArrayElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:array(definition) return self end
---@param definition BetaMoonStructureRepeatElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:repeatElement(definition) return self end
---@param definition BetaMoonStructureChanceElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:chance(definition) return self end
---@param definition BetaMoonStructureChoiceElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:choice(definition) return self end
---@param definition BetaMoonStructureLootElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:loot(definition) return self end
---@param definition BetaMoonStructureMarkerElement
---@return BetaMoonStructureBuilder self
function StructureBuilder:marker(definition) return self end
---@param definition BetaMoonStructureDocumentProcessor
---@return BetaMoonStructureBuilder self
function StructureBuilder:processor(definition) return self end
---@return BetaMoonCompiledStructure
function StructureBuilder:compile() return CompiledStructure end
---@return BetaMoonStructureBuilder
function StructureBuilder:clone() return StructureBuilder end

---@class BetaMoonStructureReplacement
---@field from BetaMoonBlockReference|integer|string
---@field to BetaMoonBlockReference|integer|string

---@class BetaMoonStructureMetadataTransform
---@field block BetaMoonBlockReference|integer|string
---@field clockwise? integer[] Exactly 16 outputs for metadata inputs 0 through 15.
---@field leftRight? integer[] Exactly 16 outputs for metadata inputs 0 through 15.
---@field frontBack? integer[] Exactly 16 outputs for metadata inputs 0 through 15.

---@class BetaMoonStructureProcessors
---@field includeAir? boolean Air is ignored by default.
---@field replace? BetaMoonStructureReplacement[]
---@field decay? number Deterministic removal probability from 0 through 1.
---@field replaceOnly? (BetaMoonBlockReference|integer|string)[]
---@field tileCollision? 'reject'|'preserve' Existing tile entities reject the structure by default.
---@field unknownMetadata? 'reject'|'preserve' Transformed nonzero metadata without an adapter rejects by default.
---@field metadataTransforms? BetaMoonStructureMetadataTransform[]

---@alias BetaMoonTerrainSurface 'world_surface'|'surface'|'solid_surface'|'ocean_floor'|'fluid_surface'

---@class BetaMoonTerrainMaskSelector
---@field states? string[] Include support cells using these palette-state names.
---@field excludeStates? string[] Exclude support cells using these palette-state names.
---@field tags? string[] Include support cells carrying selected state or element tags.
---@field excludeTags? string[] Exclude support cells carrying any listed tag.
---@field match? 'any'|'all' Tag match mode; defaults to any.
---@field bounds? BetaMoonStructureBounds Authored local-coordinate bounds.
---@field height? integer|{min: integer, max: integer} Authored local support height filter.
---@field nearMarker? string|{name: string, radius: integer} Require a marker within the horizontal radius.

---@class BetaMoonTerrainMaskExclusion
---@field states? string[]
---@field tags? string[]

---@class BetaMoonTerrainFootprint
---@field source? 'support'|'base_bounds'|'template_bounds'|'clearance'|'named'|'authored' Defaults to support.
---@field shape? 'support_footprint'|'mask'|'bounds'|'convex_hull'|'rounded_bounds'|'authored' Defaults to mask.
---@field name? string Named terrain mask when source is named/authored.
---@field cells? integer[][] Explicit authored `{x, z}` cells.
---@field select? BetaMoonTerrainMaskSelector
---@field exclude? BetaMoonTerrainMaskExclusion
---@field padding? integer Horizontal dilation from 0 through 8.
---@field inset? integer Horizontal erosion from 0 through 8; required support may not be removed.
---@field cornerRadius? integer Rounded-bounds corner radius from 0 through 16.
---@field preserveHoles? boolean Retain authored holes while applying a filled shape.

---@class BetaMoonTerrainMaterialState
---@field block BetaMoonBlockReference|integer|string
---@field metadata? integer
---@field weight? integer Positive deterministic selection weight.

---@class BetaMoonTerrainMaterialPalette
---@field layers BetaMoonTerrainMaterialState[] Deterministic coordinate-stable palette.

---@alias BetaMoonTerrainMaterial BetaMoonBlockReference|integer|string|{block: BetaMoonBlockReference|integer|string, metadata: integer?}|BetaMoonTerrainMaterialPalette

---@alias BetaMoonTerrainReplacementTag '#ordinary_terrain'|'#replaceable'|'#terrain_and_vegetation'|'#solid_terrain_material'

---@class BetaMoonTerrainReplacementSelector
---@field preset? 'ordinary_terrain'|'terrain_and_vegetation'|'replaceable' Optional preset included by the selector.
---@field blocks? (BetaMoonBlockReference|integer|string)[] Explicitly included blocks.
---@field excludeBlocks? (BetaMoonBlockReference|integer|string)[] Blocks excluded even when a preset or tag includes them.
---@field tags? BetaMoonTerrainReplacementTag[] Compiled built-in terrain classifiers.
---@field excludeTags? BetaMoonTerrainReplacementTag[] Classifiers excluded before includes are evaluated.
---@field match? 'any'|'all' Whether all included tags must match; defaults to any.

---@alias BetaMoonTerrainReplacementPolicy 'ordinary_terrain'|'terrain_and_vegetation'|'replaceable'|BetaMoonTerrainReplacementSelector

---@class BetaMoonFoundationEdge
---@field type? 'hard'|'stepped'|'blended'|'natural'|'authored' Defaults to hard.
---@field stepEvery? integer Vertical blocks per outward step, from 1 through 16.
---@field maxExpansion? integer Maximum horizontal skirt expansion, from 0 through 8.
---@field mask? string Named mask required by an authored edge.

---@class BetaMoonFoundationPolicy
---@field footprint? BetaMoonTerrainFootprint|string
---@field edge? BetaMoonFoundationEdge
---@field material? BetaMoonTerrainMaterial Defaults to cobblestone.
---@field capMaterial? BetaMoonTerrainMaterial Defaults to material.
---@field edgeMaterial? BetaMoonTerrainMaterial Defaults to material.
---@field fillMaterial? BetaMoonTerrainMaterial Defaults to material.
---@field maxDepth? integer Maximum required depth from 1 through 32; defaults to 6.
---@field replace? BetaMoonTerrainReplacementPolicy Defaults to terrain_and_vegetation.
---@field fluids? 'reject'|'replace'|'preserve' Defaults to reject.
---@field maxUnsupportedSpan? integer Optional maximum unsupported horizontal run.
---@field requireSupportRatio? number Required pre-existing support fraction from 0 through 1.
---@field maxBlocks? integer Maximum foundation writes; defaults to 4096.

---@class BetaMoonTerraceTransition
---@field type? 'hard'|'stepped'|'graded'|'blended'|'natural'|'authored' Defaults to hard.
---@field radius? integer Bounded transition radius from 0 through 8.
---@field maxStep? integer Maximum transition-height change from 1 through 8.
---@field mask? string Named mask required by an authored transition.

---@class BetaMoonTerracePolicy
---@field footprint? BetaMoonTerrainFootprint|string
---@field transition? BetaMoonTerraceTransition
---@field maxCutDepth? integer From 0 through 16; defaults to 3.
---@field maxFillDepth? integer From 0 through 16; defaults to 6.
---@field topMaterial? BetaMoonTerrainMaterial Defaults to sample_surface.
---@field fillMaterial? BetaMoonTerrainMaterial Defaults to sample_subsurface.
---@field replace? BetaMoonTerrainReplacementPolicy Defaults to ordinary_terrain.
---@field fluids? 'reject'|'replace'|'preserve' Defaults to reject.
---@field maxBlocks? integer Maximum terrace writes; defaults to 4096.

---@class BetaMoonConformSmoothing
---@field radius integer From 1 through 4.
---@field passes integer From 1 through 8.

---@class BetaMoonConformPolicy
---@field columns 'support'|'markers'|string|BetaMoonTerrainFootprint Support, legacy markers, a named mask, or a selector.
---@field maxDisplacement? integer From 1 through 16; defaults to 4.
---@field maxStep? integer From 0 through 8; defaults to 1.
---@field smoothing? BetaMoonConformSmoothing
---@field allowEmpty? boolean Permit a conditionally empty explicit selection; defaults to false.

---@alias BetaMoonExcavationBound integer|'surface'|string|{surface: boolean, offset: integer?}

---@class BetaMoonExcavationFootprintVolume
---@field shape? 'footprint'
---@field footprint? BetaMoonTerrainFootprint|string
---@field from? BetaMoonExcavationBound Inclusive lower bound; defaults to 0.
---@field to? BetaMoonExcavationBound Inclusive upper bound; defaults to 0.
---@field vertical? {from: BetaMoonExcavationBound, to: BetaMoonExcavationBound} Alternative grouped bounds.

---@class BetaMoonExcavationBoxVolume
---@field shape 'box'
---@field min BetaMoonStructureVector
---@field max BetaMoonStructureVector

---@class BetaMoonExcavationCylinderVolume
---@field shape 'cylinder'
---@field center BetaMoonStructureVector
---@field radius integer
---@field height integer

---@class BetaMoonExcavationEllipsoidVolume
---@field shape 'ellipsoid'
---@field center BetaMoonStructureVector
---@field radii {x: integer, y: integer, z: integer}

---@class BetaMoonExcavationAuthoredVolume
---@field shape 'authored'
---@field name? string Named three-dimensional mask from excavation.masks.
---@field cells? BetaMoonStructureVector[] Exact local voxels; omit both name and cells to reuse explicit terrain_clearance voxels.

---@alias BetaMoonExcavationVolume BetaMoonExcavationFootprintVolume|BetaMoonExcavationBoxVolume|BetaMoonExcavationCylinderVolume|BetaMoonExcavationEllipsoidVolume|BetaMoonExcavationAuthoredVolume

---@class BetaMoonExcavationPolicy: BetaMoonExcavationFootprintVolume
---@field volumes? BetaMoonExcavationVolume[] Multiple volumes; mutually exclusive with the simple footprint fields.
---@field masks? table<string, BetaMoonStructureVector[]> Reusable transformed three-dimensional authored voxel masks.
---@field result? 'air' Only air is currently supported.
---@field replace? BetaMoonTerrainReplacementPolicy Defaults to ordinary_terrain.
---@field fluids? 'reject'|'drain'|'preserve' Defaults to reject.
---@field maxBlocks? integer Maximum unique excavation cells; defaults to 4096.

---@class BetaMoonStructureTerrain
---@field mode? 'exact'|'fit'|'foundation'|'terrace'|'conform' Defaults to exact, preserving the supplied Y without terrain adaptation.
---@field surface? BetaMoonTerrainSurface Surface sampled by adaptive modes; defaults to solid_surface.
---@field anchor? 'minimum'|'maximum'|'median'|'mean'|'center'|'percentile' Rigid fit anchor; defaults to median.
---@field percentile? number Anchor percentile from 0 through 1 when anchor is percentile.
---@field maxSlope? integer Maximum height range across the support footprint, from 0 through 32; defaults to 2.
---@field maxStep? integer Maximum height change between neighboring support columns, from 0 through 32; defaults to maxSlope.
---@field requireSupportRatio? number Required directly supported footprint fraction from 0 through 1.
---@field verticalOffset? integer Final resolved-anchor offset from -32 through 32, shared by structure geometry and every terrain operation.
---@field masks? table<string, BetaMoonTerrainFootprint> Reusable transformed two-dimensional masks.
---@field foundation? BetaMoonFoundationPolicy Explicit foundation policy for mode foundation; legacy flat fields remain supported.
---@field terrace? BetaMoonTerracePolicy Explicit terrace policy for mode terrace; legacy flat fields remain supported.
---@field conform? BetaMoonConformPolicy Explicit conforming-column selection for mode conform.
---@field excavation? BetaMoonExcavationPolicy Independent bounded excavation available with every mode.
---@field foundationBlock? BetaMoonBlockReference|integer|string Foundation fill block; defaults to cobblestone in foundation mode and sampled local material in terrace mode.
---@field foundationMeta? integer Foundation metadata from 0 through 15.
---@field maxFoundationDepth? integer Maximum fill below each support column, from 1 through 32; defaults to 6.
---@field maxCutDepth? integer Terrace cut limit from 0 through 16; defaults to 3.
---@field maxFillDepth? integer Terrace fill limit from 0 through 16; defaults to 3.
---@field padding? integer Terrace padding from 0 through 8.
---@field blendRadius? integer Terrace transition radius from 0 through 8.
---@field maxBlendStep? integer Maximum height adjustment per blend ring, from 1 through 8.
---@field maxConformDisplacement? integer Maximum vertical movement for terrain_conform columns, from 1 through 16.

---@class BetaMoonStructureDefinition
---@field displayName? string Optional generation-settings label; falls back to the canonical key.
---@field key string
---@field path? string Package-relative gameplay-data path under assets/. Defaults to assets/<namespace>/worldgen/structures/<key>.json.
---@field template? BetaMoonStructureDocument|BetaMoonStructureBuilder|BetaMoonCompiledStructure Inline structure source; mutually exclusive with path.
---@field rotation? 'none'|'clockwise_90'|'clockwise_180'|'counterclockwise_90'|'random'|'random_horizontal'
---@field mirror? 'none'|'left_right'|'front_back'|'random'
---@field processors? BetaMoonStructureProcessors
---@field terrain? BetaMoonStructureTerrain Optional terrain relationship. Omit to retain exact placement.

---@class BetaMoonRegionalStructurePiece
---@field pool string Connector pool read from `connector` markers in the referenced template.
---@field structure BetaMoonWorldFeatureSelector Local structure template eligible for this pool.
---@field weight? integer Positive selection weight; defaults to 1.

---@class BetaMoonRegionalStructureMarkers
---@field entities? boolean Run `entity` markers after a chunk slice commits.

---@class BetaMoonRegionalStructureDefinition
---@field displayName? string Optional generation-settings label; falls back to the canonical key.
---@field stage? 'surface_structures'|'underground_structures'
---@field spatial? BetaMoonSpatialSelector
---@field tags? string[] Namespaced region and generation tags.
---@field key string
---@field start BetaMoonWorldFeatureSelector Root local structure template.
---@field dimensions? BetaMoonDimensionSelection Defaults to the native Overworld.
---@field spacing? integer Region spacing in chunks, from 2 through 512; defaults to 32.
---@field separation? integer Minimum region-edge separation, from 0 through spacing - 1; defaults to 8.
---@field salt? integer Stable seed salt.
---@field height? integer|{type: BetaMoonTerrainSurface, offset: integer?}|{type: 'fixed', value: integer} Defaults to world-surface height.
---@field site? BetaMoonStructureSite|string Optional footprint-aware environment profile shared by every rigid piece.
---@field siteSearch? {attempts: integer?, radius: integer?} Bounded deterministic fallback positions inside the candidate chunk; defaults to no fallback.
---@field connectorVerticalTolerance? integer Maximum terrain-fit vertical shift for child pieces, from 0 through 16; defaults to 0.
---@field pieces? BetaMoonRegionalStructurePiece[] Weighted connector-pool pieces. Omit for a root-only structure.
---@field maxDepth? integer Connector depth from 0 through 16; defaults to 4.
---@field maxPieces? integer Total piece limit from 1 through 128; defaults to 32.
---@field maxDistance? integer Maximum horizontal distance from the start, from 16 through 512 and no more than spacing * 16; defaults to 128.
---@field terminationChance? number Per-connector stop chance from 0 through 1; defaults to 0.2.
---@field markers? BetaMoonRegionalStructureMarkers Optional post-block marker passes.

---@class BetaMoonRegionalStructureLocation
---@field x integer
---@field y integer|nil Available after the start plan has been generated.
---@field z integer
---@field chunkX integer
---@field chunkZ integer
---@field generated boolean Whether the start is already recorded in the current world.

---@class BetaMoonRegionalStructureReference
---@field displayName string Presentation label or canonical key.
local RegionalStructureReference = {}
---@return string
function RegionalStructureReference:getKey() return '' end
---@param world BetaMoonActionWorld
---@param x integer
---@param z integer
---@param maxRegions? integer Search radius from 0 through 128; defaults to 32.
---@return BetaMoonRegionalStructureLocation|nil
---@overload fun(self: BetaMoonRegionalStructureReference, world: BetaMoonActionWorld, position: BetaMoonXZPosition, maxRegions?: integer): BetaMoonRegionalStructureLocation|nil
function RegionalStructureReference:locate(world, x, z, maxRegions) end

---@class BetaMoonStructureExportOptions
---@field includeAir? boolean
---@field origin? BetaMoonPositionI Must be inside the selected cuboid.

---@class BetaMoonStructureRegistry
local WorldStructures = {}
---@param initial? BetaMoonStructureDocument Initial visible builder data; it is copied.
---@return BetaMoonStructureBuilder
function WorldStructures:builder(initial) return StructureBuilder end
---@param definition BetaMoonStructureDefinition
---@return BetaMoonWorldFeatureReference
function WorldStructures:add(definition) return WorldFeatureReference end
---@param key string
---@return BetaMoonWorldFeatureReference|nil
function WorldStructures:get(key) end
---@param key string
---@return BetaMoonWorldFeatureReference
function WorldStructures:getRequired(key) return WorldFeatureReference end

---@class BetaMoonLootTableReference
---@field key string Canonical registered loot-table key.
local LootTableReference = {}

---@class BetaMoonLootTableDefinition
---@field key string Canonical registration key.
---@field path? string Package-relative gameplay-data path under assets/. Defaults to assets/<namespace>/loot_tables/<key-path>.json.
---@field pools? BetaMoonLootPool[] Inline table data; mutually exclusive with path.

---@class BetaMoonLootTableRegistry
local LootTables = {}
---@param definition BetaMoonLootTableDefinition
---@return BetaMoonLootTableReference
function LootTables:add(definition) return LootTableReference end
---@param key string
---@return BetaMoonLootTableReference|nil
function LootTables:get(key) end
---@param key string
---@return BetaMoonLootTableReference
function LootTables:getRequired(key) return LootTableReference end
---@param definition BetaMoonRegionalStructureDefinition
---@return BetaMoonRegionalStructureReference
function WorldStructures:addRegional(definition) return RegionalStructureReference end
---@param key string
---@return BetaMoonRegionalStructureReference|nil
function WorldStructures:getRegional(key) end
---@param key string
---@return BetaMoonRegionalStructureReference
function WorldStructures:getRegionalRequired(key) return RegionalStructureReference end
---@param world BetaMoonActionWorld
---@param minX integer
---@param minY integer
---@param minZ integer
---@param maxX integer
---@param maxY integer
---@param maxZ integer
---@param options? BetaMoonStructureExportOptions
---@return string json Validated readable structure JSON for the caller to save in its package.
function WorldStructures:export(world, minX, minY, minZ, maxX, maxY, maxZ, options) return '' end

---@class BetaMoonWorldHeightProvider
---@field output? string Authored height-output name for type=authored.
---@field type? 'uniform'|'triangular'|'normal'|'fixed'|'surface'|'world_surface'|'solid_surface'|'ocean_floor'|'fluid_surface'|'underground'|'cave_floor'|'ceiling'|'authored'
---@field min? integer
---@field max? integer
---@field value? integer Fixed height.
---@field offset? integer Surface offset.
---@field minDepth? integer Minimum depth below solid_surface for underground sampling.
---@field maxDepth? integer Maximum depth below solid_surface for underground sampling.
---@field minimumClearance? integer Required open height for cave_floor sampling.

---@class BetaMoonStructureSite
---@field type? 'any'|'land_surface'|'underwater'|'underground'|'cave'|'fluid_surface'
---@field scope? 'origin'|'support_footprint'|'clearance_mask'|'full_bounds'
---@field medium? 'any'|'air'|'water'|'lava'|'any_fluid'|'solid'
---@field minDepthBelowSurface? integer
---@field maxDepthBelowSurface? integer
---@field minFluidDepth? integer
---@field maxFluidDepth? integer
---@field minFluidCoverage? number Fraction from 0 through 1.
---@field maxFluidCoverage? number Fraction from 0 through 1.
---@field minExistingAirRatio? number Fraction from 0 through 1 used for cave validation.
---@field minSolidCover? integer
---@field maxSolidCover? integer
---@field requireSky? boolean Applies to every position selected by scope.

---@class BetaMoonWorldPlacementConditions
---@field fluid? string|BetaMoonFluidReference Exact native or custom fluid identity at the placement origin.
---@field ground? (BetaMoonBlockReference|integer|string)[]|BetaMoonBlockReference|integer|string
---@field requireSky? boolean
---@field air? boolean
---@field water? boolean
---@field lava? boolean
---@field minLight? integer
---@field maxLight? integer
---@field site? BetaMoonStructureSite|string Optional footprint-aware structure environment profile.

---@class BetaMoonWorldPlacementDefinition
---@field displayName? string Optional generation-settings label; falls back to the canonical key.
---@field spatial? BetaMoonSpatialSelector
---@field key string
---@field feature BetaMoonWorldFeatureSelector
---@field stage? BetaMoonWorldGenerationStage Owned profiles execute this stage when enabled; native worlds retain post-population ordering.
---@field dimensions? BetaMoonDimensionSelection
---@field attempts? integer|{min: integer, max: integer}|{perChunk: integer|{min: integer, max: integer}, extraChance: number?, probability: number?, rarity: integer?}
---@field position? {height: integer|BetaMoonWorldHeightProvider, horizontal: 'chunk'|'grid'?, gridSpacing: integer?}
---@field conditions? BetaMoonWorldPlacementConditions
---@field biomes? string[]|{include: string[]?, exclude: string[]?, includeTags: string[]?, excludeTags: string[]?} Display names, keyed biome IDs, and tag filters are supported.
---@field before? BetaMoonWorldPlacementSelector[]
---@field after? BetaMoonWorldPlacementSelector[]
---@field priority? integer Lower priorities execute first after explicit dependencies.
---@field salt? integer
---@field successLimit? integer

---@class BetaMoonWorldPlacementRegistry
local WorldPlacements = {}
---@param definition BetaMoonWorldPlacementDefinition
---@return BetaMoonWorldPlacementReference
function WorldPlacements:add(definition) return WorldPlacementReference end
---@param key string
---@return BetaMoonWorldPlacementReference|nil
function WorldPlacements:get(key) end
---@param key string
---@return BetaMoonWorldPlacementReference
function WorldPlacements:getRequired(key) return WorldPlacementReference end

---@class BetaMoonBiomeSpawn
---@field entity BetaMoonBiomeEntity
---@field weight integer

---@class BetaMoonSurfaceLayer
---@field block BetaMoonBlockReference|integer|string
---@field depth integer|{min: integer, max: integer} Layer thickness from 1 through 32.

---@class BetaMoonSurfaceDefinition
---@field key string
---@field replace? (BetaMoonBlockReference|integer|string)[]|BetaMoonBlockReference|integer|string Existing base blocks the surface may replace.
---@field layers BetaMoonSurfaceLayer[] One through sixteen top-to-bottom layers, with a combined maximum depth of 64.
---@field underwaterBlock? BetaMoonBlockReference|integer|string Replaces the first layer below sea level.
---@field seaLevel? integer Defaults to 64.

---@class BetaMoonSurfaceReference
local WorldSurfaceReference = {}
---@return string
function WorldSurfaceReference:getKey() return '' end

---@class BetaMoonSurfaceRegistry
local WorldSurfaces = {}
---@param definition BetaMoonSurfaceDefinition
---@return BetaMoonSurfaceReference
function WorldSurfaces:add(definition) return WorldSurfaceReference end
---@param key string
---@return BetaMoonSurfaceReference|nil
function WorldSurfaces:get(key) end
---@param key string
---@return BetaMoonSurfaceReference
function WorldSurfaces:getRequired(key) return WorldSurfaceReference end

---@class BetaMoonBiomeReference
---@field key string Stable BetaMoon key, or the display name for a native biome.
---@field displayName string Biome label used in menus and name-based lookups.
---@field name string Legacy alias of displayName.
---@field owner string
---@field isVanilla boolean
---@field isBetaMoon boolean
---@field exists boolean
---@field color integer
---@field foliageColor integer
---@field surface {top: integer, filler: integer}
---@field weather {snow: boolean, rain: boolean}
---@field range {temperature: {min: number, max: number}, humidity: {min: number, max: number}}|nil
---@field trees {type: BetaMoonBiomeTreeMode, bigTreeChance: integer}|nil
---@field spawns table<BetaMoonBiomeSpawnGroup, BetaMoonBiomeSpawn[]>
---@field override fun(self: BetaMoonBiomeReference, definition: table): BetaMoonOverrideHandle
local WorldBiomeReference = {}
---@return string
function WorldBiomeReference:getKey() return '' end

---@class BetaMoonBiomeQuery
---@field displayName? string Case-insensitive biome label filter. Takes precedence over name.
---@field name? string Legacy alias of displayName.
---@field owner? string
---@field vanilla? boolean

---@alias BetaMoonBiomeSelector string|BetaMoonBiomeReference
---@alias BetaMoonSurfaceSelector string|BetaMoonSurfaceReference

---@class BetaMoonBiomeDecorator
---@field placements (BetaMoonWorldPlacementSelector|BetaMoonWorldPlacementDefinition)[] Existing placements become templates and inline placements default to `surface_features`.

---@class BetaMoonBiomeDefinition
---@field displayName? string Biome label. Falls back to name, then the canonical key. Required without key or name.
---@field key? string Stable biome key. Omit it only for the legacy range facade.
---@field name? string Legacy alias of displayName; used only when displayName is omitted.
---@field basedOn BetaMoonBiomeName|nil
---@field color integer|nil
---@field foliageColor integer|nil
---@field tags? string[] Keyed tags used by placement and BetaMoon entity-spawn filters.
---@field surface BetaMoonSurfaceSelector|{top: BetaMoonBlockReference|integer|nil, filler: BetaMoonBlockReference|integer|nil, rule: BetaMoonSurfaceSelector|nil}|nil
---@field surfaceRule? BetaMoonSurfaceSelector Alias for `surface.rule` when retaining legacy top/filler fields.
---@field decorator? BetaMoonBiomeDecorator
---@field decorators? (BetaMoonWorldPlacementSelector|BetaMoonWorldPlacementDefinition)[] Compact alias for `decorator.placements`.
---@field range {temperature: {min: number, max: number}|nil, humidity: {min: number, max: number}|nil}|nil Legacy vanilla-climate mapping; prefer a biome source for keyed biomes.
---@field trees {type: BetaMoonBiomeTreeMode|nil, bigTreeChance: integer|nil}|nil Legacy unkeyed biome tree selection; keyed biomes use decorators.
---@field weather {snow: boolean|nil, rain: boolean|nil}|nil
---@field spawns table<BetaMoonBiomeSpawnGroup, BetaMoonBiomeSpawn[]>|nil

---@class BetaMoonBiomeClimateEntry
---@field spatial? BetaMoonSpatialSelector
---@field weight? number
---@field biome BetaMoonBiomeSelector
---@field temperature number[]|{min: number, max: number}
---@field humidity number[]|{min: number, max: number}
---@field priority? integer Higher priority wins overlapping climate cells; equal priorities use canonical biome-key order.

---@class BetaMoonFixedBiomeSourceDefinition
---@field key? string
---@field type 'fixed'
---@field biome BetaMoonBiomeSelector
---@field active? boolean
---@field priority? integer

---@class BetaMoonVanillaClimateBiomeSourceDefinition
---@field fallback? BetaMoonBiomeSelector|'vanilla'
---@field key? string
---@field type 'vanilla_climate'|'spatial_climate'
---@field entries BetaMoonBiomeClimateEntry[] One through 256 entries.
---@field active? boolean
---@field priority? integer

---@alias BetaMoonBiomeSourceDefinition BetaMoonFixedBiomeSourceDefinition|BetaMoonVanillaClimateBiomeSourceDefinition

---@class BetaMoonBiomeSourceReference
local WorldBiomeSourceReference = {}
---@return string
function WorldBiomeSourceReference:getKey() return '' end

---@class BetaMoonBiomeSourceRegistry
local WorldBiomeSources = {}
---@param definition BetaMoonBiomeSourceDefinition
---@return BetaMoonBiomeSourceReference
function WorldBiomeSources:add(definition) return WorldBiomeSourceReference end
---@param key string
---@return BetaMoonBiomeSourceReference|nil
function WorldBiomeSources:get(key) end
---@param key string
---@return BetaMoonBiomeSourceReference
function WorldBiomeSources:getRequired(key) return WorldBiomeSourceReference end


---@alias BetaMoonScalarExpression number|string|BetaMoonSpatialFieldReference|BetaMoonScalarNode
---@class BetaMoonScalarNode
---@field type 'constant'|'reference'|'x'|'y'|'z'|'noise'|'distance'|'spots'|'random_hash'|'y_gradient'|'biome_value'|'add'|'subtract'|'multiply'|'divide'|'min'|'max'|'abs'|'negate'|'square'|'cube'|'sqrt'|'power'|'floor'|'ceil'|'round'|'clamp'|'map_range'|'smoothstep'|'curve'|'spline'|'terrace'|'lerp'|'select'|'range_choice'|'shift'|'scale_coordinates'|'rotate_2d'|'cache_2d'|'cache_cell'|'cache_once'|'find_top_surface'
---@field value? number
---@field field? string|BetaMoonSpatialFieldReference
---@field input? BetaMoonScalarExpression
---@field inputs? BetaMoonScalarExpression[] Arithmetic add/multiply/min/max: 2..8 inputs.
---@field left? BetaMoonScalarExpression
---@field right? BetaMoonScalarExpression
---@field exponent? integer Integer power in 0..16.
---@field min? number
---@field max? number
---@field noise? string|BetaMoonSpatialNoiseReference|BetaMoonSpatialNoiseDefinition
---@field scale? {x: number?, y: number?, z: number?} Noise coordinate frequencies, each at most 1024 in magnitude.
---@field anchor? string|BetaMoonSpatialAnchorReference Original anchor: minecraft:anchor/original_spawn.
---@field blocksPerUnit? number
---@field metric? 'euclidean'|'manhattan'|'chebyshev'
---@field salt? integer|string
---@field cellSize? integer
---@field chance? number
---@field radius? {min: number, max: number}
---@field amplitude? number
---@field excludeRadius? number Exclusion around original spawn.
---@field property? 'temperature'|'humidity' Native positional climate inputs, each in 0..1.
---@field fromY? number
---@field toY? number
---@field fromValue? number
---@field toValue? number
---@field fromMin? number
---@field fromMax? number
---@field toMin? number
---@field toMax? number
---@field clamp? boolean
---@field points? {at: number, value: number}[] Ordered curve/spline control points.
---@field x? BetaMoonScalarExpression
---@field y? BetaMoonScalarExpression
---@field z? BetaMoonScalarExpression
---@field degrees? number
---@field alpha? BetaMoonScalarExpression
---@field from? BetaMoonScalarExpression
---@field to? BetaMoonScalarExpression
---@field whenTrue? BetaMoonScalarExpression
---@field whenFalse? BetaMoonScalarExpression
---@field stepHeight? number
---@field blend? number
---@field threshold? number
---@field minY? integer
---@field maxY? integer

---@class BetaMoonSpatialNoiseDefinition
---@field key? string namespace:noise/path.
---@field algorithm? 'value_noise_v1'|'perlin_v1'|'simplex_2d_v1'|'beta_octaves_v1'
---@field seedSalt? integer|string
---@field firstOctave? integer -24..16.
---@field amplitudes? number[] 1..16 finite amplitudes; absolute sum in (0,1024].
---@field normalization? 'bounded'|'none'

---@class BetaMoonSpatialFieldDefinition
---@field dimension? BetaMoonDimensionTarget Direct sampling elsewhere fails; spatial selectors have zero weight there.
---@field key string namespace:field/path.
---@field node BetaMoonScalarExpression Graphs have at most 256 expanded nodes and depth 32.
---@field range? {min: number, max: number} Must conservatively contain the compiled range.

---@class BetaMoonSpatialAnchorDefinition
---@field type? 'fixed'
---@field key string namespace:anchor/path.
---@field x integer
---@field z integer
---@field dimension? BetaMoonDimensionTarget Default minecraft:overworld.

---@class BetaMoonSpatialSelector
---@field field string|BetaMoonSpatialFieldReference Must not depend on Y.
---@field min? number Inclusive lower eligibility bound.
---@field max? number Inclusive upper eligibility bound.
---@field weight? {at: number, value: number}[] Increasing input coordinates and weights in 0..4.

---@class BetaMoonFieldSample
---@field value number
---@field signature string
---@class BetaMoonFieldTraceSample
---@field node string Graph-node diagnostic path.
---@field x number
---@field y number
---@field z number
---@field value number
---@class BetaMoonFieldInspection: BetaMoonFieldSample
---@field trace BetaMoonFieldTraceSample[] At most 512 evaluations, in completion order.
---@field traceTruncated boolean
---@field min number
---@field max number
---@field sampleWork integer Conservative work estimate for one sample.
---@field nodes integer
---@field dependencies integer Bit flags: X=1, Y=2, Z=4, seed=8, original anchor=16, climate=32.

---@class BetaMoonGenerationReference
---@field key string
local GenerationReference = {}
---@return string
function GenerationReference:getKey() return self.key end

---@class BetaMoonSpatialNoiseReference: BetaMoonGenerationReference
local SpatialNoiseReference = {}
---@class BetaMoonSpatialAnchorReference: BetaMoonGenerationReference
local SpatialAnchorReference = {}
---@class BetaMoonSpatialFieldReference: BetaMoonGenerationReference
local SpatialFieldReference = {}
---@param world BetaMoonActionWorld
---@param x number
---@param z number
---@overload fun(self: BetaMoonSpatialFieldReference, world: BetaMoonActionWorld, x: number, y: number, z: number): BetaMoonFieldSample|nil, string?
---@return BetaMoonFieldSample|nil, string? reason
---@overload fun(self: BetaMoonSpatialFieldReference, world: BetaMoonActionWorld, position: BetaMoonXZVector): BetaMoonFieldSample|nil, string?
function SpatialFieldReference:sample(world, x, z) end
---@param world BetaMoonActionWorld
---@param x number
---@param z number
---@overload fun(self: BetaMoonSpatialFieldReference, world: BetaMoonActionWorld, x: number, y: number, z: number): BetaMoonFieldInspection|nil, string?
---@return BetaMoonFieldInspection|nil, string? reason
---@overload fun(self: BetaMoonSpatialFieldReference, world: BetaMoonActionWorld, position: BetaMoonXZVector): BetaMoonFieldInspection|nil, string?
function SpatialFieldReference:inspect(world, x, z) end
---Exports a bounded CSV slice to BetaMoon's debug directory.
---@param world BetaMoonActionWorld
---@param options? {axis: 'xz'|'xy'|'yz'?, startX: number?, startY: number?, startZ: number?, width: integer?, height: integer?, step: number?}
---@return string|nil path, string? reason
function SpatialFieldReference:exportSlice(world, options) end


---@alias BetaMoonRawBlockState integer|string|BetaMoonBlockReference|{block: integer|string|BetaMoonBlockReference, metadata: integer?, state: table<string, boolean|string>?}
---@class BetaMoonMaterialRule
---@field type 'block'|'reference'|'weighted'|'sequence'|'when'
---@field block? BetaMoonRawBlockState
---@field metadata? integer
---@field state? table<string, boolean|string>
---@field material? string|BetaMoonMaterialRuleReference
---@field choices? {block: BetaMoonRawBlockState, weight: integer?, metadata: integer?, state: table<string, boolean|string>?}[]
---@field salt? integer|string
---@field rules? (BetaMoonMaterialRule|BetaMoonRawBlockState|string)[]
---@field condition? BetaMoonMaterialCondition
---@field thenRule? BetaMoonMaterialRule|BetaMoonRawBlockState|string
---@field elseRule? BetaMoonMaterialRule|BetaMoonRawBlockState|string
---@class BetaMoonMaterialCondition
---@field type 'below_y'|'y_range'|'surface_depth'|'derived_surface_depth'|'stone_depth'|'liquid_depth'|'slope'|'exposure'|'biome'|'field'|'all'|'any'|'not'
---@field y? number
---@field min? number
---@field max? number
---@field selector? string Biome key/name or #namespaced:tag.
---@field field? BetaMoonScalarExpression
---@field to? 'air'|'fluid' Exposure immediately above the cell.
---@field conditions? BetaMoonMaterialCondition[]
---@field condition? BetaMoonMaterialCondition
---@class BetaMoonMaterialRuleDefinition
---@field key string namespace:material/path.
---@field rule BetaMoonMaterialRule|BetaMoonRawBlockState|string

---@class BetaMoonTerrainHeightLayer
---@field key string Unique local layer key.
---@field type 'noise'|'ridge'|'valley'|'terrace'
---@field scale? number At least 16 blocks.
---@field amplitude? number Magnitude at most 64.
---@field salt? integer|string
---@field stepHeight? integer 1..32.
---@field blend? number 0..1; terrace interpolation toward the unquantized envelope.
---@field fieldCurve? BetaMoonScalarExpression X/Z-only multiplier bounded within -4..4.
---@class BetaMoonTerrainHeightProfileDefinition
---@field key? string namespace:terrain/path.
---@field dimension? 'overworld'
---@field baseHeight number 1..126.
---@field layers? BetaMoonTerrainHeightLayer[] At most 8 ordered layers.
---@field heightClamp? {min: integer, max: integer} Within 1..126.
---@field surfaceSlopeLimit? number Positive diagnostic threshold.

---@class BetaMoonTerrainSourceDefinition
---@field key? string namespace:terrain_source/path.
---@field type 'native'|'void'|'flat'|'heightmap'|'density'|'beta_compatible'|'profile_map'|'compose'
---@field minY? integer 0..127.
---@field maxY? integer 0..127, at least minY.
---@field layers? {block: BetaMoonRawBlockState, depth: integer, metadata: integer?, state: table<string, boolean|string>?}[]
---@field height? BetaMoonScalarExpression X/Z-only envelope; floored once when filling.
---@field ceiling? BetaMoonScalarExpression Optional inclusive upper envelope for heightmap bands.
---@field inside? 'between'|'outside' Side of the two envelopes filled with the solid material.
---@field noise? {continental: BetaMoonScalarExpression?, erosion: BetaMoonScalarExpression?} Beta-compatible X/Z overrides bounded in -1..1.
---@field density? BetaMoonScalarExpression Positive values are solid; exact zero is empty.
---@field solidWhen? 'positive'
---@field cell? {x: integer?, y: integer?, z: integer?} Power-of-two interpolation cells in 1..16; defaults 4,8,4.
---@field preliminarySurface? BetaMoonScalarExpression X/Z-only intended surface for density materials.
---@field material? BetaMoonMaterialRule|BetaMoonRawBlockState|string
---@field solid? BetaMoonMaterialRule|BetaMoonRawBlockState|string
---@field above? BetaMoonRawBlockState
---@field air? BetaMoonRawBlockState
---@field fluid? BetaMoonRawBlockState|{level: BetaMoonScalarExpression, material: BetaMoonRawBlockState}
---@field seaLevel? BetaMoonScalarExpression X/Z-only level bounded in -1..127.
---@field floorHeight? integer -1 disables the floor; otherwise inclusive Y in 0..127.
---@field floorMaterial? BetaMoonRawBlockState
---@field spawnPlatform? {block: BetaMoonRawBlockState, size: integer?, y: integer?} Void-source platform around saved original spawn; odd size 1..31, Y 0..125.
---@field preset? 'vanilla_beta' Fixed raw Beta basis; parameter changes create a customized variant.
---@field baseHeight? number Beta basis default 68.
---@field heightScale? number Beta basis vertical scaling, in (0,8].
---@field detailScale? number Beta basis density detail multiplier, in 0..8.
---@field entries? BetaMoonTerrainProfileEntry[] profile_map only.
---@field fallback? string|BetaMoonTerrainHeightProfileReference|BetaMoonTerrainHeightProfileDefinition|'vanilla'
---@field blendWidth? integer 0..256; zero permits sharp profile boundaries.
---@field children? {source: string|BetaMoonTerrainSourceReference|BetaMoonTerrainSourceDefinition, operation: 'replace'|'union'|'intersection'|'subtract'?, mask: BetaMoonScalarExpression?, min: number?, max: number?}[] compose only.
---@class BetaMoonTerrainProfileEntry
---@field profile string|BetaMoonTerrainHeightProfileReference|BetaMoonTerrainHeightProfileDefinition
---@field biomes? {include: string[]?, exclude: string[]?, includeTags: string[]?, excludeTags: string[]?}
---@field spatial? BetaMoonSpatialSelector
---@field weight? number In (0,1024].
---@class BetaMoonTerrainSample
---@field height number Fractional authored envelope, or derived surface height where no envelope is provided.
---@field signature string
---@field sourceKey? string
---@field profileKey? string
---@field slope? number Height-profile central-difference slope.
---@field slopeLimitExceeded? boolean Whether its diagnostic threshold is exceeded.
---@field profiles? {key: string, weight: number}[] profile_map blend contributions.

---@class BetaMoonPopulationPolicyDefinition
---@field key? string namespace:population/path.
---@field native? 'all'|'none'|BetaMoonNativePopulationCategories
---@field betamoon? BetaMoonOwnedPopulationStages
---@class BetaMoonNativePopulationCategories
---@field lakes? boolean
---@field dungeons? boolean
---@field clay? boolean
---@field ores? boolean
---@field trees? boolean
---@field vegetation? boolean
---@field springs? boolean
---@field snow? boolean
---@field animals? boolean Native natural spawning; independent of custom entity rules.
---@class BetaMoonOwnedPopulationStages
---@field undergroundStructures? boolean
---@field undergroundFeatures? boolean
---@field surfaceStructures? boolean
---@field surfaceFeatures? boolean
---@field vegetation? boolean
---@field entities? boolean Custom natural spawning.
---@field postProcess? boolean

---@class BetaMoonCarverDefinition
---@field key? string namespace:carver/path.
---@field type 'field'|'tunnel'|'room'|'ravine'|'compose'|'native_caves'
---@field field? BetaMoonScalarExpression
---@field min? number
---@field max? number
---@field children? (string|BetaMoonCarverReference|BetaMoonCarverDefinition)[] compose only.
---@field operation? 'union'|'intersection'
---@field probability? number Origin-chunk probability in 0..1.
---@field count? integer 1..4 starts per successful origin chunk.
---@field minY? integer
---@field maxY? integer
---@field radius? number In (0,16].
---@field verticalRadius? number In (0,48].
---@field length? integer 1..96.
---@field salt? integer|string
---@field replaceable? BetaMoonRawBlockState[] Defaults to stone, grass and dirt.
---@field ["protected"]? BetaMoonRawBlockState[] Bedrock is always protected.
---@field avoidFluids? boolean
---@field carveBlock? BetaMoonRawBlockState
---@field belowLevel? integer -1..127.
---@field belowBlock? BetaMoonRawBlockState
---@field biomes? {include: string[]?, exclude: string[]?, includeTags: string[]?, excludeTags: string[]?} Carver column filters.
---@field profiles? (string|BetaMoonTerrainHeightProfileReference)[] Match positive blend contributions from a profile-map source.

---@class BetaMoonTerrainOverrideDefinition
---@field key string namespace:terrain_override/path.
---@field displayName? string Generation Settings label; defaults to the canonical key.
---@field bases string[] One or more compatible presets: "minecraft" or namespace:generator/path.
---@field biomes? {include: string[]?, exclude: string[]?, includeTags: string[]?, excludeTags: string[]?} Native display names or canonical biome keys; exclusions win.
---@field region? {minX: integer?, maxX: integer?, minZ: integer?, maxZ: integer?, selector: BetaMoonSpatialSelector?} Inclusive X/Z bounds and optional seed-based selector.
---@field blend? {width: integer?, side: 'inside'|'both'?} Width 0..256; default inside with no fade.
---@field priority? integer -1000..1000; lower values run first.
---@field before? string[] Canonical override keys that must run after this package.
---@field after? string[] Canonical override keys that must run before this package.
---@field terrain? {mode: 'inherit'|'replace'?, source: string|BetaMoonTerrainSourceReference?} Replacement requires an owned terrain source.
---@field materials? {mode: 'inherit'|'add'|'replace'?, rule: BetaMoonMaterialRule|BetaMoonRawBlockState|string?} Add targets stone; replace targets all non-air except bedrock. Applied before carving and surfaces.
---@field carvers? {mode: 'inherit'|'add'|'replace'|'none'?, entries: (string|BetaMoonCarverReference)[]?}
---@field surfaces? {mode: 'inherit'|'replace'|'none'?, surface: string|BetaMoonSurfaceReference?} Replacement uses a registered surface rule set after carving.
---@field population? {disableNative: string[]?, disablePlacements: string[]?} Suppress native categories or owned placement/structure keys at the feature origin; world-level switches remain authoritative.
---@class BetaMoonTerrainOverrideDiagnostic
---@field key string
---@field displayName string
---@field enabled boolean
---@field reason 'not_in_save'|'disabled_by_player'|'disabled_by_parent'|'outside_target'|'active'
---@field influence number 0..1 at the sampled X/Z position.
---@field selected boolean Whether the deterministic transition cell receives this package.
---@field order integer One-based effective order; zero when disabled.
---@field channels string[]
---@field signature string
---@class BetaMoonTerrainOverridePoint
---@field preset string
---@field biome string Canonical saved-world biome at this X/Z position.
---@field x integer
---@field z integer
---@field packages BetaMoonTerrainOverrideDiagnostic[]
---@class BetaMoonTerrainOverrideChunkEntry
---@field key string
---@field enabled boolean
---@field order integer
---@field minInfluence number
---@field maxInfluence number
---@field influencedColumns integer
---@field selectedColumns integer
---@field channels string[]
---@field signature string
---@class BetaMoonTerrainOverrideChunk
---@field preset string
---@field chunkX integer
---@field chunkZ integer
---@field packages BetaMoonTerrainOverrideChunkEntry[]

---@class BetaMoonGenerationSelection
---@field include? string[] Canonical placement/feature/structure keys.
---@field exclude? string[] Exclusions win.
---@field includeTags? string[]
---@field excludeTags? string[]
---@class BetaMoonGeneratorProfileDefinition
---@field key string namespace:generator/path.
---@field displayName? string Optional label in Create World; defaults to the canonical key.
---@field dimensions {overworld: BetaMoonGeneratorDimension}
---@class BetaMoonGeneratorDimension
---@field nativeBase? 'overworld'|'nether'|'sky' Default overworld. Hell/Sky native population supports all or none; climate remains the native family climate.
---@field terrain string|BetaMoonTerrainSourceReference|BetaMoonTerrainSourceDefinition
---@field biomeSource? string|BetaMoonBiomeSourceReference|BetaMoonBiomeSourceDefinition
---@field surfaces? 'inherit'|'none'
---@field carvers? (string|BetaMoonCarverReference|BetaMoonCarverDefinition)[]
---@field population? string|BetaMoonPopulationPolicyReference|BetaMoonPopulationPolicyDefinition
---@field spawn? {mode: 'surface'?, requireSafeGround: boolean?} Safe spawn is required by default.
---@field heightOutputs? table<string, string|BetaMoonSpatialFieldReference> Named authored X/Z fields.
---@field placementHeightmap? 'world_surface'|'solid_surface'|'ocean_floor'|'fluid_surface'
---@field features? BetaMoonGenerationSelection
---@field structures? BetaMoonGenerationSelection

---@class BetaMoonTerrainSourceReference: BetaMoonGenerationReference
local TerrainSourceReference = {}
---@class BetaMoonTerrainHeightProfileReference: BetaMoonGenerationReference
local TerrainHeightProfileReference = {}
---@class BetaMoonMaterialRuleReference: BetaMoonGenerationReference
local MaterialRuleReference = {}
---@class BetaMoonPopulationPolicyReference: BetaMoonGenerationReference
local PopulationPolicyReference = {}
---@class BetaMoonCarverReference: BetaMoonGenerationReference
local CarverReference = {}
---@class BetaMoonTerrainOverrideReference: BetaMoonGenerationReference
local TerrainOverrideReference = {}
---@class BetaMoonGeneratorProfileReference: BetaMoonGenerationReference
local GeneratorProfileReference = {}
---@param world BetaMoonActionWorld
---@param x integer
---@param z integer
---@return BetaMoonTerrainSample|nil, string? reason
---@overload fun(self: BetaMoonTerrainSourceReference, world: BetaMoonActionWorld, position: BetaMoonXZPosition): BetaMoonTerrainSample|nil, string?
function TerrainSourceReference:sample(world, x, z) end
---@param world BetaMoonActionWorld
---@param x integer
---@param z integer
---@return BetaMoonTerrainSample|nil, string? reason
---@overload fun(self: BetaMoonTerrainHeightProfileReference, world: BetaMoonActionWorld, position: BetaMoonXZPosition): BetaMoonTerrainSample|nil, string?
function TerrainHeightProfileReference:sample(world, x, z) end
---@class BetaMoonGeneratorDescription
---@field displayName string Preset label or canonical key.
---@field key string
---@field owner string
---@field signature string
---@field nativeTerrain boolean
---@field surfaces boolean
---@field carvers integer
---@field stages BetaMoonWorldGenerationStage[]
---@field stagePolicy table<string, string> Enabled/disabled policy decisions for each logical stage.
---@field nativeCategories string[] Enabled native population categories.
---@field contentFilters table<string, BetaMoonGenerationSelection>
---@field dependencies table<string, string>
---@class BetaMoonGeneratorChunkPreview: BetaMoonGeneratorDescription
---@field chunkX integer
---@field chunkZ integer
---@field rawHash string Hash of raw block IDs and metadata, before population.
---@field timings {terrainMs: number, carversMs: number, surfacesMs: number}
---@field heightmaps table<string, integer[]> Each map is Z-major with 256 values; empty height is -1.
---@field materials table<string, integer> Counts by block-ID:metadata.
---@return BetaMoonGeneratorDescription|nil, string? reason
function GeneratorProfileReference:describe() end
---@param world BetaMoonActionWorld
---@param chunkX integer
---@param chunkZ integer
---@return BetaMoonGeneratorChunkPreview|nil, string? reason No chunks are loaded or published.
---@overload fun(self: BetaMoonGeneratorProfileReference, world: BetaMoonActionWorld, position: BetaMoonChunkPosition): BetaMoonGeneratorChunkPreview|nil, string?
function GeneratorProfileReference:previewChunk(world, chunkX, chunkZ) end
---Exports the raw preview's heightmaps and identity to CSV in BetaMoon's debug directory.
---@param world BetaMoonActionWorld
---@param chunkX integer
---@param chunkZ integer
---@return string|nil path, string? reason
---@overload fun(self: BetaMoonGeneratorProfileReference, world: BetaMoonActionWorld, position: BetaMoonChunkPosition): string|nil, string?
function GeneratorProfileReference:exportChunk(world, chunkX, chunkZ) end

---@param world BetaMoonActionWorld
---@param output string
---@param x integer
---@param z integer
---@return number|nil, string? reason
---@overload fun(self: BetaMoonGeneratorProfileReference, world: BetaMoonActionWorld, output: string, position: BetaMoonXZPosition): number|nil, string?
function GeneratorProfileReference:sampleHeightOutput(world, output, x, z) end

---@class BetaMoonSpatialNoiseRegistry
local SpatialNoises = {}
---@param definition BetaMoonSpatialNoiseDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonSpatialNoiseReference
function SpatialNoises:add(definition) return SpatialNoiseReference end
---@param key string
---@return BetaMoonSpatialNoiseReference|nil
function SpatialNoises:get(key) end
---@param key string
---@return BetaMoonSpatialNoiseReference
function SpatialNoises:getRequired(key) return SpatialNoiseReference end

---@class BetaMoonSpatialFieldRegistry
local SpatialFields = {}
---@param definition BetaMoonSpatialFieldDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonSpatialFieldReference
function SpatialFields:add(definition) return SpatialFieldReference end
---@param key string
---@return BetaMoonSpatialFieldReference|nil
function SpatialFields:get(key) end
---@param key string
---@return BetaMoonSpatialFieldReference
function SpatialFields:getRequired(key) return SpatialFieldReference end

---@class BetaMoonSpatialAnchorRegistry
local SpatialAnchors = {}
---@param definition BetaMoonSpatialAnchorDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonSpatialAnchorReference
function SpatialAnchors:add(definition) return SpatialAnchorReference end
---@param key string
---@return BetaMoonSpatialAnchorReference|nil
function SpatialAnchors:get(key) end
---@param key string
---@return BetaMoonSpatialAnchorReference
function SpatialAnchors:getRequired(key) return SpatialAnchorReference end

---@class BetaMoonTerrainSourceRegistry
local TerrainSources = {}
---@param definition BetaMoonTerrainSourceDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonTerrainSourceReference
function TerrainSources:add(definition) return TerrainSourceReference end
---@param key string
---@return BetaMoonTerrainSourceReference|nil
function TerrainSources:get(key) end
---@param key string
---@return BetaMoonTerrainSourceReference
function TerrainSources:getRequired(key) return TerrainSourceReference end

---@class BetaMoonTerrainHeightProfileRegistry
local TerrainProfiles = {}
---@param definition BetaMoonTerrainHeightProfileDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonTerrainHeightProfileReference
function TerrainProfiles:add(definition) return TerrainHeightProfileReference end
---@param key string
---@return BetaMoonTerrainHeightProfileReference|nil
function TerrainProfiles:get(key) end
---@param key string
---@return BetaMoonTerrainHeightProfileReference
function TerrainProfiles:getRequired(key) return TerrainHeightProfileReference end

---@class BetaMoonTerrainOverrideRegistry
local TerrainOverrides = {}
---@param definition BetaMoonTerrainOverrideDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonTerrainOverrideReference
function TerrainOverrides:add(definition) return TerrainOverrideReference end
---@param key string
---@return BetaMoonTerrainOverrideReference|nil
function TerrainOverrides:get(key) end
---@param key string
---@return BetaMoonTerrainOverrideReference
function TerrainOverrides:getRequired(key) return TerrainOverrideReference end
---@param world BetaMoonActionWorld
---@param x integer
---@param z integer
---@return BetaMoonTerrainOverridePoint
---@overload fun(self: BetaMoonTerrainOverrideRegistry, world: BetaMoonActionWorld, position: BetaMoonXZPosition): BetaMoonTerrainOverridePoint
function TerrainOverrides:inspect(world, x, z) end
---@param world BetaMoonActionWorld
---@param chunkX integer
---@param chunkZ integer
---@return BetaMoonTerrainOverrideChunk
---@overload fun(self: BetaMoonTerrainOverrideRegistry, world: BetaMoonActionWorld, position: BetaMoonChunkPosition): BetaMoonTerrainOverrideChunk
function TerrainOverrides:inspectChunk(world, chunkX, chunkZ) end

---@class BetaMoonMaterialRuleRegistry
local MaterialRules = {}
---@param definition BetaMoonMaterialRuleDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonMaterialRuleReference
function MaterialRules:add(definition) return MaterialRuleReference end
---@param key string
---@return BetaMoonMaterialRuleReference|nil
function MaterialRules:get(key) end
---@param key string
---@return BetaMoonMaterialRuleReference
function MaterialRules:getRequired(key) return MaterialRuleReference end

---@class BetaMoonPopulationPolicyRegistry
local PopulationPolicies = {}
---@param definition BetaMoonPopulationPolicyDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonPopulationPolicyReference
function PopulationPolicies:add(definition) return PopulationPolicyReference end
---@param key string
---@return BetaMoonPopulationPolicyReference|nil
function PopulationPolicies:get(key) end
---@param key string
---@return BetaMoonPopulationPolicyReference
function PopulationPolicies:getRequired(key) return PopulationPolicyReference end

---@class BetaMoonCarverRegistry
local WorldCarvers = {}
---@param definition BetaMoonCarverDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonCarverReference
function WorldCarvers:add(definition) return CarverReference end
---@param key string
---@return BetaMoonCarverReference|nil
function WorldCarvers:get(key) end
---@param key string
---@return BetaMoonCarverReference
function WorldCarvers:getRequired(key) return CarverReference end

---@class BetaMoonGeneratorProfileRegistry
local GeneratorProfiles = {}
---@param definition BetaMoonGeneratorProfileDefinition|{key: string?, path: string} Packaged JSON uses the same declaration schema.
---@return BetaMoonGeneratorProfileReference
function GeneratorProfiles:add(definition) return GeneratorProfileReference end
---@param key string
---@return BetaMoonGeneratorProfileReference|nil
function GeneratorProfiles:get(key) end
---@param key string
---@return BetaMoonGeneratorProfileReference
function GeneratorProfiles:getRequired(key) return GeneratorProfileReference end

---@class BetaMoonOriginalSpawn
---@field dimensionKey string Canonical sampled-world dimension.
---@field x integer
---@field y integer
---@field z integer
---@field dimension integer
---@field source 'original_spawn'
---@param world BetaMoonActionWorld
---@return BetaMoonOriginalSpawn|nil, string? reason
function SpatialAnchors:getOriginalSpawn(world) end
---Active profile; nil without a profile or during confirmed temporary Minecraft fallback.
---@param world BetaMoonActionWorld
---@return BetaMoonGeneratorProfileReference|nil
function GeneratorProfiles:getSelected(world) end

---@class BetaMoonAtmosphereFog
---@field color? integer|number[] RGB integer or normalized RGB/RGBA array.
---@field near? number
---@field far? number
---@field density? number 0 selects linear fog; otherwise exponential fog density.
---@class BetaMoonAtmosphereSound
---@field event string|BetaMoonSoundEventReference
---@field volume? number 0..4.
---@field loopIntervalTicks? integer 1..24000.
---@field fadeTicks? integer 0..1200.
---@class BetaMoonAtmosphereDefinition
---@field key string
---@field fog? BetaMoonAtmosphereFog
---@field sky? {color: integer|number[]}
---@field lightTone? integer|number[] Normalized client color multiplier; does not change world light levels.
---@field ambientSound? string|BetaMoonSoundEventReference|BetaMoonAtmosphereSound
---@field weatherSound? string|BetaMoonSoundEventReference|BetaMoonAtmosphereSound
---@class BetaMoonAtmosphereScope
---@field type 'dimension'|'biome'|'region_tag'|'sphere'|'box'
---@field id? integer Native dimension scopes only (0/-1); cannot combine with key.
---@field key? BetaMoonDimensionTarget Canonical dimension scope; cannot combine with id.
---@field keys? string[] Biome scopes.
---@field tags? string[] Biome scopes.
---@field tag? string Registered regional-structure tag.
---@field center? {x: number, y: number, z: number} Temporary spheres.
---@field radius? number Temporary spheres, at most 4096.
---@field min? {x: number, y: number, z: number} Temporary boxes.
---@field max? {x: number, y: number, z: number} Temporary boxes.
---@class BetaMoonAtmosphereBinding
---@field profile string|BetaMoonAtmosphereReference
---@field scope BetaMoonAtmosphereScope Structural bindings use dimension, biome or region_tag.
---@field priority? integer
---@field blendBlocks? integer 0..256.
---@class BetaMoonAtmosphereActivation
---@field world BetaMoonActionWorld
---@field scope BetaMoonAtmosphereScope Temporary scopes use sphere or box.
---@field priority? integer
---@field blendBlocks? integer 0..256.
---@field durationTicks? integer 1..24000; omitted means until closed or the world/owner changes.
---@field fadeTicks? integer 0..1200, default 20.
---@class BetaMoonAtmosphereHandle
local AtmosphereHandle = {}
function AtmosphereHandle:close() end
---@return boolean
function AtmosphereHandle:isActive() return false end
---@class BetaMoonAtmosphereReference: BetaMoonGenerationReference
local AtmosphereReference = {}
---@param options BetaMoonAtmosphereActivation
---@return BetaMoonAtmosphereHandle|nil, string? reason
function AtmosphereReference:activate(options) end
---@class BetaMoonAtmosphereRegistry
local Atmospheres = {}
---@param definition BetaMoonAtmosphereDefinition
---@return BetaMoonAtmosphereReference
function Atmospheres:add(definition) return AtmosphereReference end
---@param key string
---@return BetaMoonAtmosphereReference|nil
function Atmospheres:get(key) end
---@param key string
---@return BetaMoonAtmosphereReference
function Atmospheres:getRequired(key) return AtmosphereReference end
---@param definition BetaMoonAtmosphereBinding
function Atmospheres:bind(definition) end
---@param world BetaMoonActionWorld
---@param x number
---@param y number
---@param z number
---@return {profiles: {key: string, weight: number, priority: integer}[], channels: table<string, {key: string, weight: number, priority: integer}[]>}
---@overload fun(self: BetaMoonAtmosphereRegistry, world: BetaMoonActionWorld, position: BetaMoonVectorPosition): {profiles: {key: string, weight: number, priority: integer}[], channels: table<string, {key: string, weight: number, priority: integer}[]>}
function Atmospheres:getActive(world, x, y, z) return {profiles={}} end

---@class BetaMoonOreRegistry
local OreRegistry = {}
---@type BetaMoonOreReference
local OreReference

---@param definition BetaMoonOreDefinition
---@return BetaMoonOreReference
function OreRegistry:add(definition) return OreReference end
---@param key string
---@return BetaMoonOreReference|nil
function OreRegistry:get(key) end
---@param key string
---@return BetaMoonOreReference
function OreRegistry:getRequired(key) return OreReference end
---@param query? BetaMoonOreQuery
---@return BetaMoonResultList<BetaMoonOreReference>
function OreRegistry:find(query) return {} end
---@param query? BetaMoonOreQuery
---@return BetaMoonOreReference|nil
function OreRegistry:first(query) end
---@param query? BetaMoonOreQuery
---@return BetaMoonOreReference|nil
function OreRegistry:one(query) end

---@class BetaMoonBiomeRegistry
local BiomeRegistry = {}

---@param definition BetaMoonBiomeDefinition
---@return BetaMoonBiomeReference
function BiomeRegistry:add(definition) return WorldBiomeReference end
---@param key string
---@return BetaMoonBiomeReference|nil
function BiomeRegistry:get(key) end
---@param key string
---@return BetaMoonBiomeReference
function BiomeRegistry:getRequired(key) return WorldBiomeReference end
---@param query? BetaMoonBiomeQuery
---@return BetaMoonResultList<BetaMoonBiomeReference>
function BiomeRegistry:find(query) return {} end
---@param query? BetaMoonBiomeQuery
---@return BetaMoonBiomeReference|nil
function BiomeRegistry:first(query) end
---@param query? BetaMoonBiomeQuery
---@return BetaMoonBiomeReference|nil
function BiomeRegistry:one(query) end

return {
    WorldFeatures = WorldFeatures,
    WorldPlacements = WorldPlacements,
    WorldTrees = WorldTrees,
    WorldStructures = WorldStructures,
    LootTables = LootTables,
    WorldSurfaces = WorldSurfaces,
    WorldBiomeSources = WorldBiomeSources,
    OreRegistry = OreRegistry,
    BiomeRegistry = BiomeRegistry,
    SpatialNoises = SpatialNoises,
    SpatialFields = SpatialFields,
    SpatialAnchors = SpatialAnchors,
    TerrainSources = TerrainSources,
    TerrainProfiles = TerrainProfiles,
    TerrainOverrides = TerrainOverrides,
    MaterialRules = MaterialRules,
    PopulationPolicies = PopulationPolicies,
    WorldCarvers = WorldCarvers,
    GeneratorProfiles = GeneratorProfiles,
    Atmospheres = Atmospheres
}
