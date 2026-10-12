---@meta

-- Run npm run sync-api to regenerate this category.

-- --------------------------------------------------------------------------
-- CATEGORY: WORLD GENERATION
-- --------------------------------------------------------------------------

---@class BetaMoonOreDefinition
---@field key? string Stable placement key. Omit only for private compatibility registrations.
---@field block BetaMoonBlockReference|integer
---@field veinsPerChunk integer
---@field veinSize integer
---@field height {min: integer, max: integer}
---@field dimension BetaMoonDimensionName|nil `hell` and `all` remain accepted aliases; prefer the constants in `betamoon.mc.world.dimensions`.
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
---@field dimension BetaMoonDimensionName
---@field replace integer|nil
---@field biomes string[]
---@field override fun(self: BetaMoonOreReference, definition: table): BetaMoonOverrideHandle

---@class BetaMoonOreQuery
---@field key? string
---@field owner? string
---@field enabled? boolean
---@field block? BetaMoonBlockReference|integer
---@field dimension? BetaMoonDimensionName

---@alias BetaMoonWorldFeatureSelector string|BetaMoonWorldFeatureReference
---@alias BetaMoonWorldPlacementSelector string|BetaMoonWorldPlacementReference
---@alias BetaMoonWorldGenerationStage 'underground_features'|'surface_features'|'entities'|'post_process'

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
local WorldFeatureReference = {}
---@return string
function WorldFeatureReference:getKey() return '' end
---@param world BetaMoonActionWorld
---@param x integer
---@param y integer
---@param z integer
---@param options? BetaMoonWorldFeaturePlaceOptions
---@return BetaMoonWorldFeatureResult
function WorldFeatureReference:place(world, x, y, z, options) return {} end
---@param world BetaMoonActionWorld
---@param x integer
---@param y integer
---@param z integer
---@param options? BetaMoonWorldFeaturePlaceOptions
---@return BetaMoonWorldFeatureResult
function WorldFeatureReference:preview(world, x, y, z, options) return {} end

---@class BetaMoonWorldPlacementReference
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
function WorldPlacementReference:locateCandidate(world, x, z, maxChunks) end

---@class BetaMoonWorldPlacementCandidate
---@field x integer Block X at the candidate chunk center.
---@field z integer Block Z at the candidate chunk center.
---@field chunkX integer Candidate chunk X.
---@field chunkZ integer Candidate chunk Z.
---@field loaded boolean Whether the candidate chunk is currently loaded; this does not prove placement succeeded.

---@class BetaMoonWorldFeatureBase
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
---@field key string
---@field trunk BetaMoonTreeTrunkDefinition
---@field branches? BetaMoonTreeBranchDefinition
---@field canopy BetaMoonTreeCanopyDefinition
---@field ground? (BetaMoonBlockReference|integer|string)[]
---@field replace? (BetaMoonBlockReference|integer|string)[]

---@class BetaMoonVanillaTreeDefinition
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
---@field key string
---@field start BetaMoonWorldFeatureSelector Root local structure template.
---@field dimensions? BetaMoonDimensionName[]|BetaMoonDimensionName Defaults to the overworld.
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
local RegionalStructureReference = {}
---@return string
function RegionalStructureReference:getKey() return '' end
---@param world BetaMoonActionWorld
---@param x integer
---@param z integer
---@param maxRegions? integer Search radius from 0 through 128; defaults to 32.
---@return BetaMoonRegionalStructureLocation|nil
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
---@field type? 'uniform'|'triangular'|'normal'|'fixed'|'surface'|'world_surface'|'solid_surface'|'ocean_floor'|'fluid_surface'|'underground'|'cave_floor'|'ceiling'
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
---@field ground? (BetaMoonBlockReference|integer|string)[]|BetaMoonBlockReference|integer|string
---@field requireSky? boolean
---@field air? boolean
---@field water? boolean
---@field lava? boolean
---@field minLight? integer
---@field maxLight? integer
---@field site? BetaMoonStructureSite|string Optional footprint-aware structure environment profile.

---@class BetaMoonWorldPlacementDefinition
---@field key string
---@field feature BetaMoonWorldFeatureSelector
---@field stage? BetaMoonWorldGenerationStage Currently executes after vanilla population; retained for stable ordering and future precise hooks.
---@field dimensions? BetaMoonDimensionName[]
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
---@field name string
---@field displayName string
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
---@field name? string
---@field owner? string
---@field vanilla? boolean

---@alias BetaMoonBiomeSelector string|BetaMoonBiomeReference
---@alias BetaMoonSurfaceSelector string|BetaMoonSurfaceReference

---@class BetaMoonBiomeDecorator
---@field placements (BetaMoonWorldPlacementSelector|BetaMoonWorldPlacementDefinition)[] Existing placements become templates and inline placements default to `surface_features`.

---@class BetaMoonBiomeDefinition
---@field key? string Stable biome key. Omit it only for the legacy range facade.
---@field name string
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
---@field biome BetaMoonBiomeSelector
---@field temperature number[]|{min: number, max: number}
---@field humidity number[]|{min: number, max: number}
---@field priority? integer Higher priority wins overlapping climate cells; equal priorities use canonical biome-key order.

---@class BetaMoonFixedBiomeSourceDefinition
---@field key string
---@field type 'fixed'
---@field biome BetaMoonBiomeSelector
---@field active? boolean
---@field priority? integer

---@class BetaMoonVanillaClimateBiomeSourceDefinition
---@field key string
---@field type 'vanilla_climate'
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
    BiomeRegistry = BiomeRegistry
}
