this.tooltip_events <- {
	m = {},
	function create()
	{
	}

	function destroy()
	{
	}

	function onQueryTileTooltipData()
	{
		if (this.Tactical.isActive())
		{
			return this.TooltipEvents.tactical_queryTileTooltipData();
		}
		else
		{
			return this.TooltipEvents.strategic_queryTileTooltipData();
		}
	}

	function onQueryEntityTooltipData( _entityId, _isTileEntity )
	{
		if (this.Tactical.isActive())
		{
			return this.TooltipEvents.tactical_queryEntityTooltipData(_entityId, _isTileEntity);
		}
		else
		{
			return this.TooltipEvents.strategic_queryEntityTooltipData(_entityId, _isTileEntity);
		}
	}

	function onQueryRosterEntityTooltipData( _entityId )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			return entity.getRosterTooltip();
		}

		return null;
	}

	function onQuerySkillTooltipData( _entityId, _skillId )
	{
		return this.TooltipEvents.general_querySkillTooltipData(_entityId, _skillId);
	}

	function onQueryStatusEffectTooltipData( _entityId, _statusEffectId )
	{
		return this.TooltipEvents.general_queryStatusEffectTooltipData(_entityId, _statusEffectId);
	}

	function onQuerySettlementStatusEffectTooltipData( _statusEffectId )
	{
		return this.TooltipEvents.general_querySettlementStatusEffectTooltipData(_statusEffectId);
	}

	function onQueryUIItemTooltipData( _entityId, _itemId, _itemOwner )
	{
		if (this.Tactical.isActive())
		{
			return this.TooltipEvents.tactical_queryUIItemTooltipData(_entityId, _itemId, _itemOwner);
		}
		else
		{
			return this.TooltipEvents.strategic_queryUIItemTooltipData(_entityId, _itemId, _itemOwner);
		}
	}

	function onQueryUIPerkTooltipData( _entityId, _perkId )
	{
		return this.TooltipEvents.general_queryUIPerkTooltipData(_entityId, _perkId);
	}

	function onQueryUIElementTooltipData( _entityId, _elementId, _elementOwner )
	{
		return this.TooltipEvents.general_queryUIElementTooltipData(_entityId, _elementId, _elementOwner);
	}

	function onQueryFollowerTooltipData( _followerID )
	{
		if (typeof _followerID == "integer")
		{
			local renown = "\'" + this.Const.Strings.BusinessReputation[this.Const.FollowerSlotRequirements[_followerID]] + "\' (" + this.Const.BusinessReputation[this.Const.FollowerSlotRequirements[_followerID]] + ")";
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Locked Seat"
				},
				{
					id = 4,
					type = "description",
					text = "Votre compagnie manque de renom n??ceessaire pour employer plus de non-combatant. Atteignez au moins " + renown + " de renom pour d??bloquer cet emplacement. Gagnez du renom en compl??tant des ambitions, des contrats et aussi en gagnant des batailles."
				}
			];
			return ret;
		}
		else if (_followerID == "free")
		{
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Emplacement libre"
				},
				{
					id = 4,
					type = "description",
					text = "Il y a de la place ici pour ajouter un nouveau suivant non combatant dans votre compagnie."
				},
				{
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = "Ouvrir l\'??cran de recrutement"
				}
			];
			return ret;
		}
		else
		{
			local p = this.World.Retinue.getFollower(_followerID);
			return p.getTooltip();
		}
	}

	function tactical_queryTileTooltipData()
	{
		local lastTileHovered = this.Tactical.State.getLastTileHovered();

		if (lastTileHovered == null)
		{
			return null;
		}

		if (!lastTileHovered.IsDiscovered)
		{
			return null;
		}

		if (lastTileHovered.IsDiscovered && !lastTileHovered.IsEmpty && (!lastTileHovered.IsOccupiedByActor || lastTileHovered.IsVisibleForPlayer))
		{
			local entity = lastTileHovered.getEntity();
			return this.tactical_helper_getEntityTooltip(entity, this.Tactical.TurnSequenceBar.getActiveEntity(), true);
		}
		else
		{
			local tooltipContent = [
				{
					id = 1,
					type = "title",
					text = this.Const.Strings.Tactical.TerrainName[lastTileHovered.Subtype],
					icon = "ui/tooltips/height_" + lastTileHovered.Level + ".png"
				}
			];
			tooltipContent.push({
				id = 2,
				type = "description",
				text = this.Const.Strings.Tactical.TerrainDescription[lastTileHovered.Subtype]
			});

			if (lastTileHovered.IsCorpseSpawned)
			{
				tooltipContent.push({
					id = 3,
					type = "description",
					text = lastTileHovered.Properties.get("Corpse").CorpseName + " a ??t?? tu?? ici."
				});
			}

			if (this.Tactical.TurnSequenceBar.getActiveEntity() != null)
			{
				local actor = this.Tactical.TurnSequenceBar.getActiveEntity();

				if (actor.isPlacedOnMap() && actor.isPlayerControlled())
				{
					if (this.Math.abs(lastTileHovered.Level - actor.getTile().Level) == 1)
					{
						tooltipContent.push({
							id = 90,
							type = "text",
							text = "Le d??placement vous co??tera [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getActionPointCosts()[lastTileHovered.Type] + "+" + actor.getLevelActionPointCost() + "[/color][/b] AP et [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getFatigueCosts()[lastTileHovered.Type] + "+" + actor.getLevelFatigueCost() + "[/color][/b] Fatigue car ce n\'est pas ?? la m??me hauteur"
						});
					}
					else
					{
						tooltipContent.push({
							id = 90,
							type = "text",
							text = "Le d??placement vous co??tera [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getActionPointCosts()[lastTileHovered.Type] + "[/color][/b] PA et [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getFatigueCosts()[lastTileHovered.Type] + "[/color][/b] Fatigue"
						});
					}
				}
			}

			foreach( i, line in this.Const.Tactical.TerrainEffectTooltip[lastTileHovered.Type] )
			{
				tooltipContent.push(line);
			}

			if (lastTileHovered.IsHidingEntity)
			{
				tooltipContent.push({
					id = 98,
					type = "text",
					icon = "ui/icons/vision.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Cache n\'importe qui s\'y cachant tant qu\'il n\'y a personne ?? proximit??.[/color]"
				});
			}

			local allies;

			if (this.Tactical.State.isScenarioMode())
			{
				allies = this.Const.FactionAlliance[this.Const.Faction.Player];
			}
			else
			{
				allies = this.World.FactionManager.getAlliedFactions(this.Const.Faction.Player);
			}

			if (lastTileHovered.IsVisibleForPlayer && lastTileHovered.hasZoneOfControlOtherThan(allies))
			{
				tooltipContent.push({
					id = 99,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "] Est dans la zone de contr??le de l\'ennemi.[/color]"
				});
			}

			if (lastTileHovered.IsVisibleForPlayer && (lastTileHovered.SquareCoords.X == 0 || lastTileHovered.SquareCoords.Y == 0 || lastTileHovered.SquareCoords.X == 31 || lastTileHovered.SquareCoords.Y == 31))
			{
				tooltipContent.push({
					id = 99,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]N\'importe quel personnage sur ce carreau peut partir sans encombre et imm??diatement de la bataille.[/color]"
				});
			}

			if (lastTileHovered.IsVisibleForPlayer && lastTileHovered.Properties.Effect != null)
			{
				tooltipContent.push({
					id = 100,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + lastTileHovered.Properties.Effect.Tooltip + "[/color]"
				});
			}

			if (lastTileHovered.Items != null)
			{
				local result = [];

				foreach( item in lastTileHovered.Items )
				{
					result.push(item.getIcon());
				}

				if (result.len() > 0)
				{
					tooltipContent.push({
						id = 100,
						type = "icons",
						useItemPath = true,
						icons = result
					});
				}
			}

			return tooltipContent;
		}
	}

	function tactical_queryEntityTooltipData( _entityId, _isTileEntity )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			return this.tactical_helper_getEntityTooltip(entity, this.Tactical.TurnSequenceBar.getActiveEntity(), _isTileEntity);
		}

		return null;
	}

	function tactical_queryUIItemTooltipData( _entityId, _itemId, _itemOwner )
	{
		local entity = this.Tactical.getEntityByID(_entityId);
		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

		switch(_itemOwner)
		{
		case "entity":
			if (entity != null)
			{
				local item = entity.getItems().getItemByInstanceID(_itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(activeEntity, entity, item, _itemOwner);
				}
			}

			return null;

		case "ground":
		case "character-screen-inventory-list-module.ground":
			if (entity != null)
			{
				local item = this.tactical_helper_findGroundItem(entity, _itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(activeEntity, entity, item, _itemOwner);
				}
			}

			return null;

		case "stash":
		case "character-screen-inventory-list-module.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(activeEntity, entity, result.item, _itemOwner);
			}

			return null;

		case "tactical-combat-result-screen.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(activeEntity, entity, result.item, _itemOwner, true);
			}

			return null;

		case "tactical-combat-result-screen.found-loot":
			local result = this.Tactical.CombatResultLoot.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(activeEntity, entity, result.item, _itemOwner, true);
			}

			return null;
		}

		return null;
	}

	function tactical_helper_findGroundItem( _entity, _itemId )
	{
		local items = _entity.getTile() != null ? _entity.getTile().Items : null;

		if (items != null && items.len() > 0)
		{
			foreach( item in items )
			{
				if (item.getInstanceID() == _itemId)
				{
					return item;
				}
			}
		}

		return null;
	}

	function tactical_helper_getEntityTooltip( _targetedEntity, _activeEntity, _isTileEntity )
	{
		if (this.Tactical.State != null && this.Tactical.State.getCurrentActionState() == this.Const.Tactical.ActionState.SkillSelected)
		{
			if (_activeEntity != null && this.isKindOf(_targetedEntity, "actor") && _activeEntity.isPlayerControlled() && _targetedEntity != null && !_targetedEntity.isPlayerControlled())
			{
				local skill = _activeEntity.getSkills().getSkillByID(this.Tactical.State.getSelectedSkillID());

				if (skill != null)
				{
					return this.tactical_helper_addContentTypeToTooltip(_targetedEntity, _targetedEntity.getTooltip(skill), _isTileEntity);
				}
			}

			return null;
		}

		if (this.isKindOf(_targetedEntity, "entity"))
		{
			return this.tactical_helper_addContentTypeToTooltip(_targetedEntity, _targetedEntity.getTooltip(), _isTileEntity);
		}

		return null;
	}

	function tactical_helper_addContentTypeToTooltip( _entity, _tooltip, _isTileEntity )
	{
		if (_isTileEntity == false && !_entity.isHiddenToPlayer())
		{
			_tooltip.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = this.Const.Strings.Tooltip.Tactical.Hint_FocusCharacter
			});
		}

		if (_isTileEntity == true)
		{
			_tooltip.push({
				contentType = "tile-entity",
				entityId = _entity.getID()
			});
		}
		else
		{
			_tooltip.push({
				contentType = "entity",
				entityId = _entity.getID()
			});
		}

		return _tooltip;
	}

	function tactical_helper_addHintsToTooltip( _activeEntity, _entity, _item, _itemOwner, _ignoreStashLocked = false )
	{
		local stashLocked = true;

		if (this.Stash != null)
		{
			stashLocked = this.Stash.isLocked();
		}

		local tooltip = _item.getTooltip();

		if (stashLocked == true && _ignoreStashLocked == false)
		{
			if (_item.isChangeableInBattle() == false)
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/icon_locked.png",
					text = this.Const.Strings.Tooltip.Tactical.Hint_CannotChangeItemInCombat
				});
				return tooltip;
			}

			if (_activeEntity == null || _entity != null && _activeEntity != null && _entity.getID() != _activeEntity.getID())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/icon_locked.png",
					text = this.Const.Strings.Tooltip.Tactical.Hint_OnlyActiveCharacterCanChangeItemsInCombat
				});
				return tooltip;
			}

			if (_activeEntity != null && _activeEntity.getItems().isActionAffordable([
				_item
			]) == false)
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Pas assez de Points d\'action pour changer d\'objet ([b][color=" + this.Const.UI.Color.NegativeValue + "]" + _activeEntity.getItems().getActionCost([
						_item
					]) + "[/color][/b] sont requis)"
				});
				return tooltip;
			}
		}

		switch(_itemOwner)
		{
		case "entity":
			if (_item.getCurrentSlotType() == this.Const.ItemSlot.Bag && _item.getSlotType() != this.Const.ItemSlot.None)
			{
				if (stashLocked == true)
				{
					if (_item.getSlotType() != this.Const.ItemSlot.Bag && (_entity.getItems().getItemAtSlot(_item.getSlotType()) == null || _entity.getItems().getItemAtSlot(_item.getSlotType()) == "-1" || _entity.getItems().getItemAtSlot(_item.getSlotType()).isAllowedInBag()))
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "Equiper l\'objet ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
								_item,
								_entity.getItems().getItemAtSlot(_item.getSlotType()),
								_entity.getItems().getItemAtSlot(_item.getBlockedSlotType())
							]) + "[/color][/b] PA)"
						});
					}

					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Jeter l\'objet au sol ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] PA)"
					});
				}
				else
				{
					if (_item.getSlotType() != this.Const.ItemSlot.Bag && (_entity.getItems().getItemAtSlot(_item.getSlotType()) == null || _entity.getItems().getItemAtSlot(_item.getSlotType()) == "-1" || _entity.getItems().getItemAtSlot(_item.getSlotType()).isAllowedInBag()))
					{
						tooltip.push({
							id = 1,
							type = "hint",
							icon = "ui/icons/mouse_right_button.png",
							text = "Equiper l\'objet"
						});
					}

					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Mettre l\'objet dans l\'inventaire"
					});
				}
			}
			else if (stashLocked == true)
			{
				if (_item.isChangeableInBattle() && _item.isAllowedInBag() && _entity.getItems().hasEmptySlot(this.Const.ItemSlot.Bag))
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Mettre l\'objet dans le sac ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] PA)"
					});
				}

				tooltip.push({
					id = 2,
					type = "hint",
					icon = "ui/icons/mouse_right_button_ctrl.png",
					text = "Jeter l\'objet au sol ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
						_item
					]) + "[/color][/b] PA)"
				});
			}
			else
			{
				if (_item.isChangeableInBattle() && _item.isAllowedInBag())
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Mettre l\'objet dans le sac"
					});
				}

				tooltip.push({
					id = 2,
					type = "hint",
					icon = "ui/icons/mouse_right_button_ctrl.png",
					text = "Mettre l\'objet dans l\'inventaire"
				});
			}

			break;

		case "ground":
		case "character-screen-inventory-list-module.ground":
			if (_item.isChangeableInBattle())
			{
				if (_item.getSlotType() != this.Const.ItemSlot.None)
				{
					tooltip.push({
						id = 1,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Equiper l\'objet ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item,
							_entity.getItems().getItemAtSlot(_item.getSlotType()),
							_entity.getItems().getItemAtSlot(_item.getBlockedSlotType())
						]) + "[/color][/b] PA)"
					});
				}

				if (_item.isAllowedInBag())
				{
					tooltip.push({
						id = 2,
						type = "hint",
						icon = "ui/icons/mouse_right_button_ctrl.png",
						text = "Mettre l\'objet dans le sac ([b][color=" + this.Const.UI.Color.PositiveValue + "]" + _activeEntity.getItems().getActionCost([
							_item
						]) + "[/color][/b] PA)"
					});
				}
			}

			break;

		case "stash":
		case "character-screen-inventory-list-module.stash":
			if (_item.isUsable())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Utiliser l\'objet"
				});
			}
			else if (_item.getSlotType() != this.Const.ItemSlot.None && _item.getSlotType() != this.Const.ItemSlot.Bag)
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Equiper l\'objet"
				});
			}

			if (_item.isChangeableInBattle() == true && _item.isAllowedInBag())
			{
				tooltip.push({
					id = 2,
					type = "hint",
					icon = "ui/icons/mouse_right_button_ctrl.png",
					text = "Mettre l\'objet dans le sac"
				});
			}

			if (_item.getCondition() < _item.getConditionMax())
			{
				tooltip.push({
					id = 3,
					type = "hint",
					icon = "ui/icons/mouse_right_button_alt.png",
					text = _item.isToBeRepaired() ? "Retirer le marquage de r??paration de l\'objet" : "Marquer l\'objet pour qu\'il soit r??par??"
				});
			}

			break;

		case "tactical-combat-result-screen.stash":
			tooltip.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_right_button.png",
				text = "Jeter l\'objet au sol"
			});
			break;

		case "tactical-combat-result-screen.found-loot":
			if (this.Stash.hasEmptySlot())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Mettre l\'objet dans l\'inventaire"
				});
			}
			else
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "L\'inventaire est plein"
				});
			}

			break;

		case "world-town-screen-shop-dialog-module.stash":
			tooltip.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_right_button.png",
				text = "Vendre l\'objet pour [img]gfx/ui/tooltips/money.png[/img]" + _item.getSellPrice()
			});

			if (this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getCurrentBuilding() != null && this.World.State.getCurrentTown().getCurrentBuilding().isRepairOffered() && _item.getConditionMax() > 1 && _item.getCondition() < _item.getConditionMax())
			{
				local price = (_item.getConditionMax() - _item.getCondition()) * this.Const.World.Assets.CostToRepairPerPoint;
				local value = _item.m.Value * (1.0 - _item.getCondition() / _item.getConditionMax()) * 0.2 * this.World.State.getCurrentTown().getPriceMult() * this.Const.Difficulty.SellPriceMult[this.World.Assets.getEconomicDifficulty()];
				price = this.Math.max(price, value);

				if (this.World.Assets.getMoney() >= price)
				{
					tooltip.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/mouse_right_button_alt.png",
						text = "Payer [img]gfx/ui/tooltips/money.png[/img]" + price + " pour le r??parer"
					});
				}
				else
				{
					tooltip.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "Pas assez de couronnes pour payer les r??parations!"
					});
				}
			}

			break;

		case "world-town-screen-shop-dialog-module.shop":
			if (this.Stash.hasEmptySlot())
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_right_button.png",
					text = "Acheter l\'objet pour [img]gfx/ui/tooltips/money.png[/img]" + _item.getBuyPrice()
				});
			}
			else
			{
				tooltip.push({
					id = 1,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "L\'inventaire est plein"
				});
			}

			break;
		}

		return tooltip;
	}

	function strategic_queryTileTooltipData()
	{
		local lastTileHovered = this.World.State.getLastTileHovered();

		if (lastTileHovered != null)
		{
			if (this.World.Assets.m.IsShowingExtendedFootprints)
			{
				local footprints = this.World.getAllFootprintsAtPos(this.World.getCamera().screenToWorld(this.Cursor.getX(), this.Cursor.getY()), this.Const.World.FootprintsType.COUNT);
				local ret = [
					{
						id = 1,
						type = "title",
						text = "Your Lookout reports"
					}
				];

				for( local i = 1; i < footprints.len(); i = ++i )
				{
					if (footprints[i])
					{
						ret.push({
							id = 1,
							type = "hint",
							text = this.Const.Strings.FootprintsType[i] + " est pass?? r??cemment par ici"
						});
					}
				}

				if (ret.len() > 1)
				{
					return ret;
				}
			}
		}

		return null;
	}

	function strategic_queryEntityTooltipData( _entityId, _isTileEntity )
	{
		if (_isTileEntity)
		{
			local lastEntityHovered = this.World.State.getLastEntityHovered();
			local entity = this.World.getEntityByID(_entityId);

			if (lastEntityHovered != null && entity != null && lastEntityHovered.getID() == entity.getID())
			{
				return this.strategic_helper_addContentTypeToTooltip(entity, entity.getTooltip());
			}
		}
		else
		{
			local entity = this.Tactical.getEntityByID(_entityId);

			if (entity != null)
			{
				return this.strategic_helper_addContentTypeToTooltip(entity, entity.getRosterTooltip());
			}
		}

		return null;
	}

	function strategic_queryUIItemTooltipData( _entityId, _itemId, _itemOwner )
	{
		local entity = _entityId != null ? this.Tactical.getEntityByID(_entityId) : null;

		switch(_itemOwner)
		{
		case "entity":
			if (entity != null)
			{
				local item = entity.getItems().getItemByInstanceID(_itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(null, entity, item, _itemOwner);
				}
			}

			return null;

		case "ground":
		case "character-screen-inventory-list-module.ground":
			if (entity != null)
			{
				local item = this.tactical_helper_findGroundItem(entity, _itemId);

				if (item != null)
				{
					return this.tactical_helper_addHintsToTooltip(null, entity, item, _itemOwner);
				}
			}

			return null;

		case "stash":
		case "character-screen-inventory-list-module.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(null, entity, result.item, _itemOwner);
			}

			return null;

		case "craft":
			return this.World.Crafting.getBlueprint(_itemId).getTooltip();

		case "blueprint":
			return this.World.Crafting.getBlueprint(_entityId).getTooltipForComponent(_itemId);

		case "world-town-screen-shop-dialog-module.stash":
			local result = this.Stash.getItemByInstanceID(_itemId);

			if (result != null)
			{
				return this.tactical_helper_addHintsToTooltip(null, entity, result.item, _itemOwner, true);
			}

			return null;

		case "world-town-screen-shop-dialog-module.shop":
			local stash = this.World.State.getTownScreen().getShopDialogModule().getShop().getStash();

			if (stash != null)
			{
				local result = stash.getItemByInstanceID(_itemId);

				if (result != null)
				{
					return this.tactical_helper_addHintsToTooltip(null, entity, result.item, _itemOwner, true);
				}
			}

			return null;
		}

		return null;
	}

	function strategic_helper_addContentTypeToTooltip( _entity, _tooltip )
	{
		_tooltip.push({
			contentType = "tile-entity",
			entityId = _entity.getID()
		});
		return _tooltip;
	}

	function general_querySkillTooltipData( _entityId, _skillId )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			local skill = entity.getSkills().getSkillByID(_skillId);

			if (skill != null)
			{
				return skill.getTooltip();
			}
		}

		return null;
	}

	function general_queryStatusEffectTooltipData( _entityId, _statusEffectId )
	{
		local entity = this.Tactical.getEntityByID(_entityId);

		if (entity != null)
		{
			local statusEffect = entity.getSkills().getSkillByID(_statusEffectId);

			if (statusEffect != null)
			{
				local ret = statusEffect.getTooltip();

				if (statusEffect.isType(this.Const.SkillType.Background) && ("State" in this.World) && this.World.State != null)
				{
					this.World.Assets.getOrigin().onGetBackgroundTooltip(statusEffect, ret);
				}

				return ret;
			}
		}

		return null;
	}

	function general_querySettlementStatusEffectTooltipData( _statusEffectId )
	{
		local currentTown = this.World.State.getCurrentTown();

		if (currentTown != null)
		{
			local statusEffect = currentTown.getSituationByID(_statusEffectId);

			if (statusEffect != null)
			{
				return statusEffect.getTooltip();
			}
		}

		return null;
	}

	function general_queryUIPerkTooltipData( _entityId, _perkId )
	{
		local perk = this.Const.Perks.findById(_perkId);

		if (perk != null)
		{
			local ret = [
				{
					id = 1,
					type = "title",
					text = perk.Name
				},
				{
					id = 2,
					type = "description",
					text = perk.Tooltip
				}
			];
			local player = this.Tactical.getEntityByID(_entityId);

			if (!player.hasPerk(_perkId))
			{
				if (player.getPerkPointsSpent() >= perk.Unlocks)
				{
					if (player.getPerkPoints() == 0)
					{
						ret.push({
							id = 3,
							type = "hint",
							icon = "ui/icons/icon_locked.png",
							text = "Disponible, mais ce personnage n\'a pas de point d\'aptitude ?? d??penser"
						});
					}
				}
				else if (perk.Unlocks - player.getPerkPointsSpent() > 1)
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = "Bloqu?? tant que " + (perk.Unlocks - player.getPerkPointsSpent()) + " points d\'aptitude n\'ont pas ??t?? d??pens??s"
					});
				}
				else
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = "Bloqu?? tant que " + (perk.Unlocks - player.getPerkPointsSpent()) + " points d\'aptitude n\'ont pas ??t?? d??pens??s"
					});
				}
			}

			return ret;
		}

		return null;
	}

	function general_queryUIElementTooltipData( _entityId, _elementId, _elementOwner )
	{
		local entity;

		if (_entityId != null)
		{
			entity = this.Tactical.getEntityByID(_entityId);
		}

		switch(_elementId)
		{
		case "CharacterName":
			local ret = [
				{
					id = 1,
					type = "title",
					text = entity.getName()
				}
			];
			return ret;

		case "CharacterNameAndTitles":
			local ret = [
				{
					id = 1,
					type = "title",
					text = entity.getName()
				}
			];

			if ("getProperties" in entity)
			{
				foreach( p in entity.getProperties() )
				{
					local s = this.World.getEntityByID(p);
					ret.push({
						id = 2,
						type = "text",
						text = "Seigneur de " + s.getName()
					});
				}
			}

			if ("getTitles" in entity)
			{
				foreach( s in entity.getTitles() )
				{
					ret.push({
						id = 3,
						type = "text",
						text = s
					});
				}
			}

			return ret;

		case "assets.Money":
			local money = this.World.Assets.getMoney();
			local dailyMoney = this.World.Assets.getDailyMoneyCost();
			local time = this.Math.floor(money / this.Math.max(1, dailyMoney));

			if (dailyMoney == 0)
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Couronnes"
					},
					{
						id = 2,
						type = "description",
						text = "Le nombre de pi??ces que votre compagnie poss??de. Utilis?? pour payer tous vos hommes ?? midi, ainsi qu\'?? engager de nouvelles personnes ou acheter du nouvel equipement.\n\nVous ne payez actuellement personne."
					}
				];
			}
			else if (time >= 1.0 && money > 0)
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Couronnes"
					},
					{
						id = 2,
						type = "description",
						text = "Le nombre de pi??ces que votre compagnie poss??de. Utilis?? pour payer tous vos hommes ?? midi, ainsi qu\'?? engager de nouvelles personnes ou acheter du nouvel equipement.\n\nVous payez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyMoney + "[/color] couronnes par jour. Vos [color=" + this.Const.UI.Color.PositiveValue + "]" + money + "[/color] couronnes dureront encore [color=" + this.Const.UI.Color.PositiveValue + "]" + time + "[/color] jour."
					}
				];
			}
			else
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Crowns"
					},
					{
						id = 2,
						type = "description",
						text = "Le nombre de pi??ces votre compagnie poss??de. Utilis?? pour payer tous vos hommes ?? midi, ainsi qu\'?? engager de nouvelles personnes ou acheter du nouvel equipement.\n\nVous payez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyMoney + "[/color] couronnes par jour.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Vous n\'avez plus de couronnes pour payer vos hommes! Gagnez rapidement des couronnes ou vos hommes s\'en iront un par un.[/color]"
					}
				];
			}

		case "assets.InitialMoney":
			return [
				{
					id = 1,
					type = "title",
					text = "Co??t d\'embauche"
				},
				{
					id = 2,
					type = "description",
					text = "Le co??t d\'embauche sera pay?? imm??diatement en engagant un homme, pour lui prouver que vous pouvez appuyer vos mots avec des pi??ces."
				}
			];

		case "assets.Fee":
			return [
				{
					id = 1,
					type = "title",
					text = "Co??t d\'embauche"
				},
				{
					id = 2,
					type = "description",
					text = "Ce co??t sera pay?? d\'avance pour les services qui seront rendus."
				}
			];

		case "assets.TryoutMoney":
			return [
				{
					id = 1,
					type = "title",
					text = "Co??t d\'essai"
				},
				{
					id = 2,
					type = "description",
					text = "Ce paiement permet de conna??tre la recrue, ce qui r??velera ses traits (s\'il en poss??de)."
				}
			];

		case "assets.DailyMoney":
			return [
				{
					id = 1,
					type = "title",
					text = "Salaire journalier"
				},
				{
					id = 2,
					type = "description",
					text = "Ce salaire sera pay?? tous les jours pour servir sous vos ordres. Ce salaire est augment?? automatiquement de 10% par level jusqu\'au level 11, puis 3% ensuite."
				}
			];

		case "assets.Food":
			local food = this.World.Assets.getFood();
			local dailyFood = this.Math.ceil(this.World.Assets.getDailyFoodCost() * this.Const.World.TerrainFoodConsumption[this.World.State.getPlayer().getTile().Type]);
			local time = this.Math.floor(food / dailyFood);

			if (food > 0 && time > 1)
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Provisions"
					},
					{
						id = 2,
						type = "description",
						text = "Le total de provisions que vous portez. Un homme normal a besoin de 2 provisions par jour et plus surdes terrain accident??s. Vos hommes prioriserons les denr??s qui sont proches de l\'expiration. Arriver ?? cours de provisions diminuera le moral et fera fuir vos hommes avant de mourir de faim.\n\nVous utilisez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color] provisions par jour. Vos [color=" + this.Const.UI.Color.PositiveValue + "]" + food + "[/color] provisions vous permettrons de tenir encore [color=" + this.Const.UI.Color.PositiveValue + "]" + time + "[/color] jours tout au plus. Gardez ?? l\'esprit que certaines provisions peuvent pourrir!"
					}
				];
			}
			else if (food > 0 && time == 1)
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Provisions"
					},
					{
						id = 2,
						type = "description",
						text = "Le total de provisions que vous portez. Un homme normal a besoin de 2 provisions par jour et plus sur des terrains accident??s. Vos hommes prioriserons les denr??s qui sont proches de l\'expiration. Arriver ?? cours de provisions diminuera le moral et fera fuir vos hommes avant de mourir de faim.\n\nVous utilisez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color] provisions par jour.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Vous n\'avez pratiquement plus de provisions pour nourrir vos hommes! Achetez rapidement des provisions aussi vite que possible ou vos hommes d??serterons un par un avant de mourrir de faim![/color]"
					}
				];
			}
			else
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Provisions"
					},
					{
						id = 2,
						type = "description",
						text = "Le total de provisions que vous portez. Un homme normal a besoin de 2 provisions par jour et plus sur des terrains accident??s. Vos hommes prioriserons les denr??s qui sont proches de l\'expiration. Arriver ?? cours de provisions diminuera le moral et fera fuir vos hommes avant de mourir de faim.\n\nVous utilisez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color] provisions par jour.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Vous n\'avez plus de provisions pour nourrir vos hommes! Achetez rapidement des provisions aussi vite que possible ou vos hommes d??serterons un par un avant de mourrir de faim![/color]"
					}
				];
			}

		case "assets.DailyFood":
			return [
				{
					id = 1,
					type = "title",
					text = "Provisions journali??res"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de provision qu\'un homme ?? besoin par jour. Arriver ?? cours de provisions diminuera le moral et fera fuir vos hommes avant de mourir de faim."
				}
			];

		case "assets.Ammo":
			return [
				{
					id = 1,
					type = "title",
					text = "Munitions"
				},
				{
					id = 2,
					type = "description",
					text = "Un ensemble de fl??ches, carreau et d\'armes de jets utilis??s automatiquement pour remplir les carquois apr??s les batailles. Remplacer une fl??che ou un carreau utilisera une munition, remplacer un tir d\'arme ?? main utilisera jusqu\'?? deux points et remplacer une arme de jet ou une charge de lance de feu en utilisera jusqu\'?? trois. Arriver ?? court de munition laissera votre carquoi vide et vos hommes n\'auront plus rien ?? tirer. Vous ne pouvez porter plus de " + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].Ammo + this.World.Assets.m.AmmoMaxAdditional) + " munitions."
				}
			];

		case "assets.Supplies":
			local repair = this.World.Assets.getRepairRequired();
			local desc = "Ensemble d\'outils et de ressources pour garder vos armes, armures, casques et boucliers en bonne condition. Un point est n??cessaire pour r??parer 15 points de durabilit?? d\'un objet. Arrivez ?? court d\'outils peut signifier que vos armes peuvent se casser durant un combat ou laisser vos armures en mauvaise condition et donc inutile.";

			if (repair.ArmorParts > 0)
			{
				desc = desc + ("\n\nR??parer tous vos ??quipements durera [color=" + this.Const.UI.Color.PositiveValue + "]" + repair.Hours + "[/color] heures et n??cessitera ");

				if (repair.ArmorParts <= this.World.Assets.getArmorParts())
				{
					desc = desc + ("[color=" + this.Const.UI.Color.PositiveValue + "]");
				}
				else
				{
					desc = desc + ("[color=" + this.Const.UI.Color.NegativeValue + "]");
				}

				desc = desc + (repair.ArmorParts + "[/color] outils et ressources.");
			}

			desc = desc + (" Vous pouvez porter " + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].ArmorParts + this.World.Assets.m.ArmorPartsMaxAdditional) + " outils.");
			return [
				{
					id = 1,
					type = "title",
					text = "Outils et Ressources"
				},
				{
					id = 2,
					type = "description",
					text = desc
				}
			];

		case "assets.Medicine":
			local heal = this.World.Assets.getHealingRequired();
			local desc = "Les ressources m??dicales comportent des bandages, des herbes, des onguents et autres choses de la sorte, ils sont utilis??s pour soigner les blessures s??v??res que vos hommes ont eu dans la bataille. Une unit?? de ressource m??dicale est requise tous les jours pour chaque blessure pour les soigner jusqu\'?? les gu??rir. Les points de vies perdus se soignent d\'eux-m??mes.\n\nArriver ?? court de ressource m??dicale empechera vos hommes de r??cuperer de leurs blessures.";

			if (heal.MedicineMin > 0)
			{
				desc = desc + ("\n\nSoigner vos hommes prendra entre [color=" + this.Const.UI.Color.PositiveValue + "]" + heal.DaysMin + "[/color] et [color=" + this.Const.UI.Color.PositiveValue + "]" + heal.DaysMax + "[/color] jours et n??cessitera entre ");

				if (heal.MedicineMin <= this.World.Assets.getMedicine())
				{
					desc = desc + ("[color=" + this.Const.UI.Color.PositiveValue + "]");
				}
				else
				{
					desc = desc + ("[color=" + this.Const.UI.Color.NegativeValue + "]");
				}

				desc = desc + (heal.MedicineMin + "[/color] et ");

				if (heal.MedicineMax <= this.World.Assets.getMedicine())
				{
					desc = desc + ("[color=" + this.Const.UI.Color.PositiveValue + "]");
				}
				else
				{
					desc = desc + ("[color=" + this.Const.UI.Color.NegativeValue + "]");
				}

				desc = desc + (heal.MedicineMax + "[/color] ressources m??dicales.");
			}

			desc = desc + (" Vous pouvez porter " + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].Medicine + this.World.Assets.m.MedicineMaxAdditional) + " ressources m??dicales au maximum.");
			return [
				{
					id = 1,
					type = "title",
					text = "Ressources M??dicales"
				},
				{
					id = 2,
					type = "description",
					text = desc
				}
			];

		case "assets.Brothers":
			return [
				{
					id = 1,
					type = "title",
					text = "Compagnie (I, C)"
				},
				{
					id = 2,
					type = "description",
					text = "Montre l\'ensemble des informations relatives ?? votre compagnie de mercenaire."
				}
			];

		case "assets.BusinessReputation":
			return [
				{
					id = 1,
					type = "title",
					text = "Renom: " + this.World.Assets.getBusinessReputationAsText() + " (" + this.World.Assets.getBusinessReputation() + ")"
				},
				{
					id = 2,
					type = "description",
					text = "Le renom est votre r??putation en tant que mercenaire professionnel et refl??te ?? quel point les gens vous juge fiable et comp??tent. Le plus haut votre renom, le plus haut sera la r??compense et la difficult?? des contrats qui vous seront propos??s. Le renom augmentera en r??ussissant vos ambitions, vos contrats et en gagnants vos batailles, et diminuera en n\'arrivant pas ?? les faire."
				}
			];

		case "assets.MoralReputation":
			return [
				{
					id = 1,
					type = "title",
					text = "R??putation: " + this.World.Assets.getMoralReputationAsText()
				},
				{
					id = 2,
					type = "description",
					text = "Votre r??putation refl??te comment les gens dans le monde juge la conduite de votre compagnie de mercenaire en se basant sur vos actions pass??s. Avez-vous ??pargn?? vos ennemies ? Est-ce que vous br??ler les fermes et tuer la paysannerie? En se basant sur votre r??putation, les gens vous offrirons diff??rents types de contrats, de plus les contrats et les ??venements pourraient se finir diff??rement."
				}
			];

		case "assets.Ambition":
			if (this.World.Ambitions.hasActiveAmbition())
			{
				local ret = this.World.Ambitions.getActiveAmbition().getButtonTooltip();

				if (this.World.Ambitions.getActiveAmbition().isCancelable())
				{
					ret.push({
						id = 10,
						type = "hint",
						icon = "ui/icons/mouse_right_button.png",
						text = "Annuler AMbition"
					});
				}

				return ret;
			}
			else
			{
				return [
					{
						id = 1,
						type = "title",
						text = "Ambition"
					},
					{
						id = 2,
						type = "description",
						text = "Vous n\'avez pas annonc?? d\'ambition pour votre compagnie. Cela vous le sera demand?? au fur et ?? mesure que le jeu progressera."
					}
				];
			}

		case "stash.FreeSlots":
			return [
				{
					id = 1,
					type = "title",
					text = "Capacit??"
				},
				{
					id = 2,
					type = "description",
					text = "Montre le chargement actuel et maximum de votre inventaire."
				}
			];

		case "stash.ActiveRoster":
			return [
				{
					id = 1,
					type = "title",
					text = "Hommes en formation"
				},
				{
					id = 2,
					type = "description",
					text = "Montre le nombre actuel et maximum d\'hommes plac??s en formatoin pour se battre dans la prochaine bataille.\n\nGlisser et d??poser vos hommes o?? vous voulez qu\'ils soient; La ligne du haut est la ligne de front fa??ant l\'ennemi, la seconde ligne est la ligne ?? l\'arri??re, et la ligne du bas est la ligne de r??serve (vos hommes qui ne prendront pas part au combat)."
				}
			];

		case "ground.Slots":
			return [
				{
					id = 1,
					type = "title",
					text = "Sol"
				},
				{
					id = 2,
					type = "description",
					text = "Montre les items actuellement au sol."
				}
			];

		case "character-stats.ActionPoints":
			return [
				{
					id = 1,
					type = "title",
					text = "Points d\'Action"
				},
				{
					id = 2,
					type = "description",
					text = "Les Points d\'Action (PA) sont utilis??s pour chaque action, comme bouger ou utiliser une capacit??. Une fois que tous les points sont utilis??s, le personnage actuel terminera son tour automatiquement. Les PA sont restaur??s au d??but de chaque tour."
				}
			];

		case "character-stats.Hitpoints":
			return [
				{
					id = 1,
					type = "title",
					text = "Points de vie"
				},
				{
					id = 2,
					type = "description",
					text = "Les points de vie repr??sentent les dommages qu\'un personnage peut prendre avant de mourrir. Une fois qu\'ils atteignent z??ro, le personnage est consid??r?? mort. Plus les point de vies sont ??lev??s, moins le caract??re ?? de \"chance\" de subir une blessure incapacitante quand il est touch??."
				}
			];

		case "character-stats.Morale":
			return [
				{
					id = 1,
					type = "title",
					text = "Moral"
				},
				{
					id = 2,
					type = "description",
					text = "Le moral est un des cinq ??tat qui repr??sente la condition mentale de vos combatants ainsi que leur efficacit?? en combat. Au plus bas, ils fuiront, le personnage sera alors hors de contr??le - m??me s\'ils se rallieront probablement de nouveau. Le Moral change au fur et ?? mesure que la bataille progresse, avec des personnages ayant un moral assez haut, ils auront moins tendence ?? tomber dans un moral bas (et donc ?? fuir). Beaucoup de vos ennemies sont aussi affect??s par le moral.\n\nDes v??rifications de moral sont lanc??s ?? ces diff??rentes occasions:\n- Tuer un ennemi\n- Voir un ennemi ??tre tu??\n- Voir un alli?? ??tre tu??\n- Voir un alli?? fuir\n- Etre touch?? et subir plus de 15 point de vie de d??g??ts\n- Etre engag?? en m??l??e par plus d\'un ennemi\n- Utiliser certaines comp??tences, comme \'Rallier\'"
				}
			];

		case "character-stats.Fatigue":
			return [
				{
					id = 1,
					type = "title",
					text = "Fatigue"
				},
				{
					id = 2,
					type = "description",
					text = "La Fatigue est gagn?? pour chaque action, comme bouger, utiliser une comp??tence, en se faisant toucher en combat ou encore en esquivant. La Fatigue est reduite de 15 ?? chaque tour ou autant qu\'il est n??cessaire pour qu\'un personnage commence son tour avec son mximum de fatigue moins 15. Si un personnage accumule trop de fatigue, il aura probablement besoin de se reposer pendant un ou plusieurs tours (en ne faisant rien) avant d\'avoir la possibilit?? d\'utiliser des capacit??s plus sp??cialis??s."
				}
			];

		case "character-stats.MaximumFatigue":
			return [
				{
					id = 1,
					type = "title",
					text = "Fatigue Maximum"
				},
				{
					id = 2,
					type = "description",
					text = "La Fatigue Maximum est la Fatigue maximum qu\'un personnage peut accumuler avant d\'??tre dans l\'impossibilit?? d\'effectuer plus d\'actions. Elle est r??duite en portant des ??quipements lourds, sp??cifiquement les armures."
				}
			];

		case "character-stats.ArmorHead":
			return [
				{
					id = 1,
					type = "title",
					text = "Casque (Armure)"
				},
				{
					id = 2,
					type = "description",
					text = "Le casque (armure) prot??ge, ??tonnament, la t??te, qui est plus difficile ?? toucher que le corps, mais qui est plus vuln??rable aux d??gats. Plus vous avez de l\'armure (casque), moins il y aura de d??gats appliqu??s ?? vos points de vies si vous vous faites toucher ?? la t??te."
				}
			];

		case "character-stats.ArmorBody":
			return [
				{
					id = 1,
					type = "title",
					text = "Corps (Armure)"
				},
				{
					id = 2,
					type = "description",
					text = "Plus vous avez de l\armure (corps) moins il y aura de d??gats appliqu??s ?? vos points de vies si vous vous faites toucher."
				}
			];

		case "character-stats.MeleeSkill":
			return [
				{
					id = 1,
					type = "title",
					text = "Ma??trise de M??l??e"
				},
				{
					id = 2,
					type = "description",
					text = "Elle d??termine la probabilit?? de base de toucher une cible avec une attaque de m??l??e, tel que les ??p??es et les lances. Elle peut ??tre augment??e quand le personnage gagne des niveaux."
				}
			];

		case "character-stats.RangeSkill":
			return [
				{
					id = 1,
					type = "title",
					text = "Ma??trise ?? distance"
				},
				{
					id = 2,
					type = "description",
					text = "Elle d??termine la probabilit?? de base de toucher une cible avec une attaque ?? distance, tel que les arcs ou les arbal??tes. Elle peut ??tre augment??e quand le personnage gagne des niveaux."
				}
			];

		case "character-stats.MeleeDefense":
			return [
				{
					id = 1,
					type = "title",
					text = "D??fense de M??l??e"
				},
				{
					id = 2,
					type = "description",
					text = "Une d??fense de m??l??e plus ??lev??e r??duit la probabilit?? de se faire toucher par une attaque de m??l??e, tel que les coups de lances. Elle peut ??tre augment??e quand le personnage gagne des niveaux ou en ??quippant un bon bouclier."
				}
			];

		case "character-stats.RangeDefense":
			return [
				{
					id = 1,
					type = "title",
					text = "D??fense ?? Distance"
				},
				{
					id = 2,
					type = "description",
					text = "Une d??fense ?? distance plus ??lev??e r??duit la probabilit?? de se faire toucher par une attaque ?? distance, tel qu\'une fl??che tir?? d\'une certaine distance. Elle peut ??tre augment??e quand le personnage gagne des niveaux ou en ??quippant un bon bouclier."
				}
			];

		case "character-stats.SightDistance":
			return [
				{
					id = 1,
					type = "title",
					text = "Vision"
				},
				{
					id = 2,
					type = "description",
					text = "La Vision, ou la distance de vue, d??termine la distance ?? laquel un personnage peut voir et donc r??v??ler ce qu\'il y a derri??re le brouillard de guerre, d??couvrir des menaces ou encore tirer avec des attaques ?? distance. Les casques lourd et la nuit peuvent la faire diminuer."
				}
			];

		case "character-stats.RegularDamage":
			return [
				{
					id = 1,
					type = "title",
					text = "Dommage"
				},
				{
					id = 2,
					type = "description",
					text = "Les d??g??ts de base que fait l\'arme actuellement ??quip??. Sera appliqu?? enti??rement s\'il n\'y a pas d\'armure prot??geant la cible. Si la cible est prot??g?? par l\'armure, les d??g??ts sont appliqu??s ?? l\'armure en se basant sur l\'efficacit?? de l\'arme contre l\'armure. Les d??g??ts occasionn??s sont modifi??s par la comp??tence utilis?? et la cible touch??."
				}
			];

		case "character-stats.CrushingDamage":
			return [
				{
					id = 1,
					type = "title",
					text = "Efficacit?? contre l\'Armure"
				},
				{
					id = 2,
					type = "description",
					text = "Le pourcentage des d??gats de base de l\'arme quand elle frappe une cible en armure. D??s que l\'armure est d??truite, les d??g??ts de l\'arme sont appliqu??s ?? 100%. Les d??g??ts occasionn??s sont modifi??s par la comp??tence utilis?? et la cible touch??."
				}
			];

		case "character-stats.ChanceToHitHead":
			return [
				{
					id = 1,
					type = "title",
					text = "Chance de toucher la t??te"
				},
				{
					id = 2,
					type = "description",
					text = "La probabilit?? de base de toucher la t??te de la cible pour des d??gats augment??s. La probabilit?? finale peut ??tre modifi??s par la comp??tence utilis??."
				}
			];

		case "character-stats.Initiative":
			return [
				{
					id = 1,
					type = "title",
					text = "Initiative"
				},
				{
					id = 2,
					type = "description",
					text = "Plus la valeur est ??lev??e, plus le personnage commencera son tour t??t. L\'Initiative est r??duite par la fatigue actuelle, ainsi que toute p??nalit?? appliqu?? ?? la Fatigue Maximum (comme les amures lourdes). En g??n??ral, quelqu\'un en armure l??g??re jouera son tour avant quelqu\'un en armure lourde, et quelqu\'un en pleine forme jouera avant quelqu\'un de fatigu??."
				}
			];

		case "character-stats.Bravery":
			return [
				{
					id = 1,
					type = "title",
					text = "D??termination"
				},
				{
					id = 2,
					type = "description",
					text = "La D??termination r??presente la volont?? et la bravoure de vos personnages. Plus elle est ??lev??e, moins vos personnages auront la probabilit?? de faire descendre le moral pendant des ??v??nements n??gatifs, et plus vos personnages auront la chance de gagner en confidence lors des ??v??nements positifs. La d??termination acte comme une d??fense contre les attaques mentales qui infligent des paniques, la peur, ou des contr??les mentale. Voir aussi: Moral."
				}
			];

		case "character-stats.Talent":
			return [
				{
					id = 1,
					type = "title",
					text = "Talent"
				},
				{
					id = 2,
					type = "description",
					text = "TODO"
				}
			];

		case "character-stats.Undefined":
			return [
				{
					id = 1,
					type = "title",
					text = "UNDEFINED"
				},
				{
					id = 2,
					type = "description",
					text = "TODO"
				}
			];

		case "character-backgrounds.generic":
			if (entity != null)
			{
				local tooltip = entity.getBackground().getGenericTooltip();
				return tooltip;
			}

			return null;

		case "character-levels.generic":
			return [
				{
					id = 1,
					type = "title",
					text = "Higher Level"
				},
				{
					id = 2,
					type = "description",
					text = "This character already has experience in combat and starts with a higher level."
				}
			];

		case "menu-screen.load-campaign.LoadButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Charger Campagne"
				},
				{
					id = 2,
					type = "description",
					text = "Charger la campagne s??lectionn??e."
				}
			];

		case "menu-screen.load-campaign.CancelButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Retour"
				},
				{
					id = 2,
					type = "description",
					text = "Revenir au menu principal."
				}
			];

		case "menu-screen.load-campaign.DeleteButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Supprimer Campagne"
				},
				{
					id = 2,
					type = "description",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]WARNING:[/color] Supprime la campagne s??lectionn??e sans d\'autres avertissements."
				}
			];

		case "menu-screen.save-campaign.LoadButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Sauvegarder la Campagne"
				},
				{
					id = 2,
					type = "description",
					text = "Sauvegarder la campagne ?? l\'emplacement selectionn??."
				}
			];

		case "menu-screen.save-campaign.CancelButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Retour"
				},
				{
					id = 2,
					type = "description",
					text = "Revenir au menu principal."
				}
			];

		case "menu-screen.save-campaign.DeleteButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Supprimer Campagne"
				},
				{
					id = 2,
					type = "description",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]WARNING:[/color] Supprime la campagne s??lectionn??e sans d\'autres avertissements."
				}
			];

		case "menu-screen.new-campaign.CompanyName":
			return [
				{
					id = 1,
					type = "title",
					text = "Nom de la Compagnie"
				},
				{
					id = 2,
					type = "description",
					text = "Le nom de votre compagnie qui sera connu aux quatres coins du monde."
				}
			];

		case "menu-screen.new-campaign.Seed":
			return [
				{
					id = 1,
					type = "title",
					text = "Map Seed"
				},
				{
					id = 2,
					type = "description",
					text = "A map seed is a unique string that determines how the world in your campaign will look like. You can see the seed of ongoing campaigns in the game menu accessible by pressing the Escape key, and then share it with friends to have them play in the same world."
				}
			];

		case "menu-screen.new-campaign.EasyDifficulty":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficult?? D??butant"
				},
				{
					id = 2,
					type = "description",
					text = "Vous ferez fasse ?? moins d\'ennemi, et ils seront plus facile, vos hommes gagneront de l\'exp??rience plus rapidement et battre en retraite pendant les bataille est plus facile.\n\nVos hommes auront un petit bonus aux chances de toucher et les ennemis une petite p??nalit??, pour faciliter votre arriv?? dans le jeu.\n\nRecommend?? pour les nouveaux joueurs."
				}
			];

		case "menu-screen.new-campaign.NormalDifficulty":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficult?? V??t??ran"
				},
				{
					id = 2,
					type = "description",
					text = "Fournit une exp??rience plus ??quilibr?? qui peut se r??v??ler plus difficile.\n\nRecommend?? pour les v??t??rans du jeu ou du genre."
				}
			];

		case "menu-screen.new-campaign.HardDifficulty":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficult?? Expert"
				},
				{
					id = 2,
					type = "description",
					text = "Vos rencontres seront plus difficiles et nombreuses.\n\nRecommend?? pour les experts du jeu qui veulent un d??fi mortel."
				}
			];

		case "menu-screen.new-campaign.EasyDifficultyEconomic":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficult?? D??butant"
				},
				{
					id = 2,
					type = "description",
					text = "Les contrats paieront plus, vous pourrez transporter plus de ressources.\n\nRecommend?? pour les nouveaux joueurs."
				}
			];

		case "menu-screen.new-campaign.NormalDifficultyEconomic":
			return [
				{
					id = 1,
					type = "title",
					text = "Veteran Difficulty"
				},
				{
					id = 2,
					type = "description",
					text = "Fournit une exp??rience plus ??quilibr?? qui peut se r??v??ler plus difficile.\n\nRecommend?? pour les v??t??rans du jeu ou du genre."
				}
			];

		case "menu-screen.new-campaign.HardDifficultyEconomic":
			return [
				{
					id = 1,
					type = "title",
					text = "Expert Difficulty"
				},
				{
					id = 2,
					type = "description",
					text = "Les contrats paieront moins, les deserteurs prendront leur ??quipement avec eux.\n\nRecommend?? pour les experts du jeu qui veulent plus de d??fi ?? g??rer les fonds et les ressources de la compagnie."
				}
			];

		case "menu-screen.new-campaign.EasyDifficultyBudget":
			return [
				{
					id = 1,
					type = "title",
					text = "Fonds de d??part - Elev??"
				},
				{
					id = 2,
					type = "description",
					text = "Vous commencerez avec plus de couronnes et de ressources.\n\nRecommend?? pour les nouveaux joueurs."
				}
			];

		case "menu-screen.new-campaign.NormalDifficultyBudget":
			return [
				{
					id = 1,
					type = "title",
					text = "Fonds de d??part - Moyen"
				},
				{
					id = 2,
					type = "description",
					text = "Recommend?? pour une exp??rience ??quilibr??."
				}
			];

		case "menu-screen.new-campaign.HardDifficultyBudget":
			return [
				{
					id = 1,
					type = "title",
					text = "Fonds de d??part - Bas"
				},
				{
					id = 2,
					type = "description",
					text = "Vous commencerez avec moins de couronnes et de ressources.\n\nRecommend?? pour les experts du jeu."
				}
			];

		case "menu-screen.new-campaign.StartingScenario":
			return [
				{
					id = 1,
					type = "title",
					text = "Sc??nario de D??part"
				},
				{
					id = 2,
					type = "description",
					text = "Choisissez comment commence votre compagnie dans le monde. En fonction de votre choix, vous commencerez avec diff??rents hommes, ??quipement, ressources et des r??gles sp??ciales."
				}
			];

		case "menu-screen.new-campaign.Ironman":
			return [
				{
					id = 1,
					type = "title",
					text = "Ironman"
				},
				{
					id = 2,
					type = "description",
					text = "Le mode Ironman d??sactive les sauvegardes manuelles. Une seule sauvegarde existera pour la compagnie, et le jeu est sauvegard?? automatiquement durant le jeu et en quittant. Perdre la compagnie signifie perdre la sauvegarde. Recommend?? pour la meilleure exp??rience une fois que vous connaissez le jeu.\n\nGardez ?? l\'esprit que les ordinateurs moins puissants pauseront probablement le jeu pendant quelques secondes pour sauvegarder."
				}
			];

		case "menu-screen.new-campaign.Exploration":
			return [
				{
					id = 1,
					type = "title",
					text = "Unexplored Map"
				},
				{
					id = 2,
					type = "description",
					text = "An optional way to play the game where the map is entirely unexplored and not visible to you at the start of your campaign. You\'ll have to discover everything on your own, which makes your campaign more difficult, but potentially also more exciting.\n\nRecommended only for experienced players that know what they\'re doing."
				}
			];

		case "menu-screen.new-campaign.EvilRandom":
			return [
				{
					id = 1,
					type = "title",
					text = "Crise de fin de jeu Al??atoire"
				},
				{
					id = 2,
					type = "description",
					text = "Une crise sera choisie al??atoirement dans la liste ci-dessous."
				}
			];

		case "menu-screen.new-campaign.EvilNone":
			return [
				{
					id = 1,
					type = "title",
					text = "No Crisis"
				},
				{
					id = 2,
					type = "description",
					text = "Il n\'y aura pas de crise de fin de jeu et vous pourrez continuer de jouer ind??finiment. Notez qu\'en s??lectionnant cette option, une partie significative du contenu du jeu et du challenge de fin ne sera pas disponible. Pas recommend?? pour une bonne exp??rience de jeu."
				}
			];

		case "menu-screen.new-campaign.EvilPermanentDestruction":
			return [
				{
					id = 1,
					type = "title",
					text = "Destruction Permanente"
				},
				{
					id = 2,
					type = "description",
					text = "Les villes, villages et ch??teaux peuvent ??tre d??truit ind??finiment pendant le crise de fin de jeu, et avoir le monde partir en fum??e est une des nombreuses fa??on de perdre la campagne."
				}
			];

		case "menu-screen.new-campaign.EvilWar":
			return [
				{
					id = 1,
					type = "title",
					text = "Guerre"
				},
				{
					id = 2,
					type = "description",
					text = "La premi??re crise de fin sera une guerre sans merci entre les maisons des nobles pour le pouvoir. Si vous survivez assez longtemps, les prochaines crises seront choisi al??atoirement."
				}
			];

		case "menu-screen.new-campaign.EvilGreenskins":
			return [
				{
					id = 1,
					type = "title",
					text = "L\'Invasion des Peaux-Vertes"
				},
				{
					id = 2,
					type = "description",
					text = "La premi??re crise de fin sera une invasion de hordes de Peaux-Vertes mena??ant de raser le monde des hommes. Si vous survivez assez longtemps, les prochaines crises seront choisi al??atoirement."
				}
			];

		case "menu-screen.new-campaign.EvilUndead":
			return [
				{
					id = 1,
					type = "title",
					text = "Fl??au des Morts-Vivant"
				},
				{
					id = 2,
					type = "description",
					text = "Dans la premi??re crise de fin les morts se l??veront de nouveau pour reprendre ce qui leur appartenait autrefois. Si vous survivez assez longtemps, les prochaines crises seront choisi al??atoirement."
				}
			];

		case "menu-screen.new-campaign.EvilCrusade":
			return [
				{
					id = 1,
					type = "title",
					text = "Guerre Sainte"
				},
				{
					id = 2,
					type = "description",
					text = "La premi??re crise de fin sera une guerre sainte entre les cultures du nord et du sud. Si vous survivez assez longtemps, les prochaines crises seront choisi al??atoirement."
				}
			];

		case "menu-screen.options.DepthOfField":
			return [
				{
					id = 1,
					type = "title",
					text = "Depth of Field"
				},
				{
					id = 2,
					type = "description",
					text = "Enabling the Depth of Field effect will render height levels below the camera in tactical combat slightly out of focus (i.e. blurry), giving more of a miniature vibe and making it easier to differentiate heights, but potentially at the expense of some detail."
				}
			];

		case "menu-screen.options.UIScale":
			return [
				{
					id = 1,
					type = "title",
					text = "UI Scale"
				},
				{
					id = 2,
					type = "description",
					text = "Change the scale of the user interface, i.e. menus and texts."
				}
			];

		case "menu-screen.options.SceneScale":
			return [
				{
					id = 1,
					type = "title",
					text = "Scene Scale"
				},
				{
					id = 2,
					type = "description",
					text = "Change the scale of the scene, i.e. everything that isn\'t the user interface, such as the characters shown on the battlefield."
				}
			];

		case "menu-screen.options.EdgeOfScreen":
			return [
				{
					id = 1,
					type = "title",
					text = "Edge of Screen"
				},
				{
					id = 2,
					type = "description",
					text = "Scroll the screen by moving the mouse cursor to the edge of the screen."
				}
			];

		case "menu-screen.options.DragWithMouse":
			return [
				{
					id = 1,
					type = "title",
					text = "Drag with Mouse"
				},
				{
					id = 2,
					type = "description",
					text = "Scroll the screen by pressing the left mouse button and dragging it (default)."
				}
			];

		case "menu-screen.options.HardwareMouse":
			return [
				{
					id = 1,
					type = "title",
					text = "Use Hardware Cursor"
				},
				{
					id = 2,
					type = "description",
					text = "Using the hardware cursor minimizes input lag when moving the mouse in the game. Disable this if you experience problems with the mouse cursor."
				}
			];

		case "menu-screen.options.HardwareSound":
			return [
				{
					id = 1,
					type = "title",
					text = "Use Hardware Sound"
				},
				{
					id = 2,
					type = "description",
					text = "Use hardware-accelerated sound playback for better performance. Disable this if you experience any issues related to sound."
				}
			];

		case "menu-screen.options.CameraFollow":
			return [
				{
					id = 1,
					type = "title",
					text = "Always Focus AI Movement"
				},
				{
					id = 2,
					type = "description",
					text = "Always have the camera centered on any AI movement visible to you."
				}
			];

		case "menu-screen.options.CameraAdjust":
			return [
				{
					id = 1,
					type = "title",
					text = "Auto-Adjust Height Levels"
				},
				{
					id = 2,
					type = "description",
					text = "Automatically adjust the camera\'s height level to see the currently active character in combat. Disabling this will prevent the camera from changing height levels when it isn\'t strictly necessary, but will also require manual adjustment of height levels when characters happen to be obstructed by terrain."
				}
			];

		case "menu-screen.options.StatsOverlays":
			return [
				{
					id = 1,
					type = "title",
					text = "Toujours afficher les barres de Point de vie"
				},
				{
					id = 2,
					type = "description",
					text = "Affiche toujours les barres de point de vie et d\'armure au dessus des personnages en combat, par d??faut ils sont seulement affich??s quand le personnage est touch??."
				}
			];

		case "menu-screen.options.OrientationOverlays":
			return [
				{
					id = 1,
					type = "title",
					text = "Show Orientation Icons"
				},
				{
					id = 2,
					type = "description",
					text = "Show icons at the edges of your screen indicating the direction in which any characters currently outside the screen are on the map."
				}
			];

		case "menu-screen.options.MovementPlayer":
			return [
				{
					id = 1,
					type = "title",
					text = "Mouvement du Joueur plus rapide"
				},
				{
					id = 2,
					type = "description",
					text = "Augmente la vitesse de d??placement des personnages contr??l??s par le joueur en combat. N\'affecte pas les comp??tence li??s au d??placement."
				}
			];

		case "menu-screen.options.MovementAI":
			return [
				{
					id = 1,
					type = "title",
					text = "Mouvement de l\'IA plus rapide"
				},
				{
					id = 2,
					type = "description",
					text = "Augmente la vitesse de d??placement des personnages contr??l??s par l\'IA en combat. N\'affecte pas les comp??tence li??s au d??placement."
				}
			];

		case "menu-screen.options.AutoLoot":
			return [
				{
					id = 1,
					type = "title",
					text = "R??colte butin automatique"
				},
				{
					id = 2,
					type = "description",
					text = "R??cup??re toujours et automatiquement la r??colte du butin apr??s un combat quand vous fermez la page du butin - du moment que vous avez de l\'espace dans votre inventaire."
				}
			];

		case "menu-screen.options.RestoreEquipment":
			return [
				{
					id = 1,
					type = "title",
					text = "Restaure l\'??quipement apr??s la Bataille"
				},
				{
					id = 2,
					type = "description",
					text = "Remplace automatiquement l\'??quipement dans l\'inventaire tel qu\'il l\'??tait avant le combat, si possible. Par exemple, si un personnage commence une bataille avec une arbal??te, mais change pour une pique au cours du combat, ils auront automatiquement l\'arbal??te en main quand la bataille est termin??e."
				}
			];

		case "menu-screen.options.AutoPauseAfterCity":
			return [
				{
					id = 1,
					type = "title",
					text = "Pause-Auto apr??s avoir quitter une Ville"
				},
				{
					id = 2,
					type = "description",
					text = "Met le jeu automatiquement en pause apr??s avoir quitt?? la ville, cela afin de ne pas perdre de temps - mais oblige d\'enlever la pause ?? chaque fois."
				}
			];

		case "menu-screen.options.AlwaysHideTrees":
			return [
				{
					id = 1,
					type = "title",
					text = "Toujours cacher les arbres"
				},
				{
					id = 2,
					type = "description",
					text = "Affiche toujours le haut des arbres ou autres gros objets en semi-transparent, plut??t que seulement quand ils cachent quelque chose."
				}
			];

		case "menu-screen.options.AutoEndTurns":
			return [
				{
					id = 1,
					type = "title",
					text = "Fini-Tour automatiquement"
				},
				{
					id = 2,
					type = "description",
					text = "Termine automatiquement le tour des personnagess que vous contr??lez d??s que vous n\'avez assez de Points d\'Action pour faire une action."
				}
			];

		case "tactical-screen.topbar.event-log-module.ExpandButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Expand/Retract Event Log"
				},
				{
					id = 2,
					type = "description",
					text = "Expands or retracts the Combat Event Log."
				}
			];

		case "tactical-screen.topbar.round-information-module.BrothersCounter":
			return [
				{
					id = 1,
					type = "title",
					text = "Alli??s"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de fr??res d\'armes controll??s par vous ou vos alli??s (controll??s par l\'IA) sur le champ de bataille."
				}
			];

		case "tactical-screen.topbar.round-information-module.EnemiesCounter":
			return [
				{
					id = 1,
					type = "title",
					text = "Ennemies"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre d\'ennemies sur le champs de bataille."
				}
			];

		case "tactical-screen.topbar.round-information-module.RoundCounter":
			return [
				{
					id = 1,
					type = "title",
					text = "Tour"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de tours jou??s depuis ue la bataille a commenc??."
				}
			];

		case "tactical-screen.topbar.options-bar-module.CenterButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Center Camera (Shift)"
				},
				{
					id = 2,
					type = "description",
					text = "Center the camera on the currently acting character."
				}
			];

		case "tactical-screen.topbar.options-bar-module.ToggleHighlightBlockedTilesButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Affiche/Cache la surbrillance sur les tuiles bloqu??s (B)"
				},
				{
					id = 2,
					type = "description",
					text = "Bacule entre afficher et cacher l\'affichage en rouge pour indiquer les tuiles bloqu??s par l\'environnement (comme les arbres) o?? les personnages ne peuvent s\'y d??placer."
				}
			];

		case "tactical-screen.topbar.options-bar-module.SwitchMapLevelUpButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Raise Camera Level (+)"
				},
				{
					id = 2,
					type = "description",
					text = "Raise camera level to see the more elevated parts of the map."
				}
			];

		case "tactical-screen.topbar.options-bar-module.SwitchMapLevelDownButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Lower Camera Level (-)"
				},
				{
					id = 2,
					type = "description",
					text = "Lower camera level and hide elevated parts of the map."
				}
			];

		case "tactical-screen.topbar.options-bar-module.ToggleStatsOverlaysButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Afficher/Cacher les barres de points de vies (Alt)"
				},
				{
					id = 2,
					type = "description",
					text = "Basculer entre afficher et cacher les barres d\'armure et de points de vie, ainsi que les ic??nes d\'effet de statut, au dessus de chaque personnage visible."
				}
			];

		case "tactical-screen.topbar.options-bar-module.ToggleTreesButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Afficher/Cacher les arbres (T)"
				},
				{
					id = 2,
					type = "description",
					text = "Basculer entre afficher et cacher les arbres et autres gros objets sur la carte."
				}
			];

		case "tactical-screen.topbar.options-bar-module.FleeButton":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Fuir le combat"
				},
				{
					id = 2,
					type = "description",
					text = "Fuyez lz combat et courrez pour vos vies. Il est mieux de se battre un autre jour ue de mourrir ici inutilement."
				}
			];

			if (!this.Tactical.State.isScenarioMode() && this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsFleeingProhibited)
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Vous ne pouvez pas fuir de ce combat."
				});
			}

			return ret;

		case "tactical-screen.topbar.options-bar-module.QuitButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Ouvrir le Menu (Esc)"
				},
				{
					id = 2,
					type = "description",
					text = "Ouvrir le menu pour ajuster les options de jeu."
				}
			];

		case "tactical-screen.turn-sequence-bar-module.EndTurnButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Finir le tour (Enter, F)"
				},
				{
					id = 2,
					type = "description",
					text = "Finir le tour du personnage actif et passer au prochain personnage."
				}
			];

		case "tactical-screen.turn-sequence-bar-module.WaitTurnButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Attendre le tour (Espace, FIN)"
				},
				{
					id = 2,
					type = "description",
					text = "Met en pause le tour du personnage actif et le place en fin de queue. Attendre ce tour, vous fera aussi agir plus tard au tour d\'apr??s."
				}
			];

		case "tactical-screen.turn-sequence-bar-module.EndTurnAllButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Finir le tour (R)"
				},
				{
					id = 2,
					type = "description",
					text = "Fini le tour, ce qui fera passer le tour ?? tous vos personnages jusqu\'?? ce que le prochain tour commence."
				}
			];

		case "tactical-screen.turn-sequence-bar-module.OpenInventoryButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Ouvrir l\'inventaire (I, C)"
				},
				{
					id = 2,
					type = "description",
					text = "Ouvre la page de personnage et d\'inventaire pour le Fr??re d\'arme actif."
				}
			];

		case "tactical-combat-result-screen.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Partir"
				},
				{
					id = 2,
					type = "description",
					text = "Quitter le combat tactiue et retourner ?? la map du monde."
				}
			];

		case "tactical-combat-result-screen.statistics-panel.LeveledUp":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Monter de niveau"
				},
				{
					id = 2,
					type = "description",
					text = "Ce personnage vient de monter de niveau! Trouvez-le dans votre compagnie, accessible depuis la map monde pour monter ses attributs et s??lectionner un Talent."
				}
			];
			return result;

		case "tactical-combat-result-screen.statistics-panel.DaysWounded":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Blessures l??g??res"
				},
				{
					id = 2,
					type = "description",
					text = "Petit bleu, petite perte de sang et autres blessures superficielles qui ont provoqu??s une perte de points de vie ?? ce personnage sans impacter leurs comp??tences."
				}
			];

			if (entity != null)
			{
				if (entity.getDaysWounded() <= 1)
				{
					result.push({
						id = 1,
						type = "text",
						icon = "ui/icons/days_wounded.png",
						text = "Sera soign?? d\'ici demain"
					});
				}
				else
				{
					result.push({
						id = 1,
						type = "text",
						icon = "ui/icons/days_wounded.png",
						text = "Sera soign?? d\'ici [color=" + this.Const.UI.Color.NegativeValue + "]" + entity.getDaysWounded() + "[/color] jours"
					});
				}
			}

			return result;

		case "tactical-combat-result-screen.statistics-panel.KillsValue":
			return [
				{
					id = 1,
					type = "title",
					text = "Tu??s"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre d\'ennemis que ce personnage a tu?? durant cette bataille."
				}
			];

		case "tactical-combat-result-screen.statistics-panel.XPReceivedValue":
			return [
				{
					id = 1,
					type = "title",
					text = "Experience Gagn??"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de point d\'exp??rience gagn?? en combattant et tuant des ennemis. Gagner assez de points d\'exp??rience permettra ?? ce personnage de montre de niveau, ce qui augmentera ses attributs et lui permettra de choisir un Talent."
				}
			];

		case "tactical-combat-result-screen.statistics-panel.DamageDealtValue":
			local result = [
				{
					id = 1,
					type = "title",
					text = "D??gats Caus??s"
				},
				{
					id = 2,
					type = "description",
					text = "Les d??gats caus??s par ce personnage pendant le combat (Points de vie et armure)."
				}
			];

			if (entity != null)
			{
				local combatStats = entity.getCombatStats();
				result.push({
					id = 1,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "A caus?? [color=" + this.Const.UI.Color.PositiveValue + "]" + combatStats.DamageDealtHitpoints + "[/color] dommages aux points de vie"
				});
				result.push({
					id = 2,
					type = "text",
					icon = "ui/icons/shield_damage.png",
					text = "A caus?? [color=" + this.Const.UI.Color.PositiveValue + "]" + combatStats.DamageDealtArmor + "[/color] dommages ?? l\'armure"
				});
			}

			return result;

		case "tactical-combat-result-screen.statistics-panel.DamageReceivedValue":
			local result = [
				{
					id = 1,
					type = "title",
					text = "D??gats Re??us"
				},
				{
					id = 2,
					type = "description",
					text = "Les d??gats re??us par ce personnage, partag??s en dommages ?? l\'armure et aux points de vie. Ces valeurs sont apr??s application des r??ductions de dommages."
				}
			];

			if (entity != null)
			{
				local combatStats = entity.getCombatStats();
				result.push({
					id = 1,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "A re??u [color=" + this.Const.UI.Color.NegativeValue + "]" + combatStats.DamageReceivedHitpoints + "[/color] de dommages aux points de vie"
				});
				result.push({
					id = 2,
					type = "text",
					icon = "ui/icons/shield_damage.png",
					text = "A re??u [color=" + this.Const.UI.Color.NegativeValue + "]" + combatStats.DamageReceivedArmor + "[/color] de dommages ?? l\'armure"
				});
			}

			return result;

		case "tactical-combat-result-screen.loot-panel.LootAllItemsButton":
			return [
				{
					id = 1,
					type = "title",
					text = "R??colte tous les objets"
				},
				{
					id = 2,
					type = "description",
					text = "R??colte tous les objets jusqu\'?? ce que l\'inventaire soit rempli."
				}
			];

		case "character-screen.left-panel-header-module.ChangeNameAndTitle":
			return [
				{
					id = 1,
					type = "title",
					text = "Changer le nom et le titre"
				},
				{
					id = 2,
					type = "description",
					text = "Cliquer ici pour changer le nom et le titre du personnage."
				}
			];

		case "character-screen.left-panel-header-module.Experience":
			return [
				{
					id = 1,
					type = "title",
					text = "Experience"
				},
				{
					id = 2,
					type = "description",
					text = "Les personnages gagnent des points d\'exp??rience quand vous ou vos alli??s tuent des ennemies en bataille. Si un combattant accumule assez d\'exp??rience, il montera de niveau et aura la possibilit?? de monter ses attributs et de s??lectionner un Talent qui offrira un bonus unique.\n\nAu dessus du level 11, les personnages sont des v??t??rans et ne gagneront plus de points de Talent, mais ils continueront de s\'ameliorer."
				}
			];

		case "character-screen.left-panel-header-module.Level":
			return [
				{
					id = 1,
					type = "title",
					text = "Niveau"
				},
				{
					id = 2,
					type = "description",
					text = "Le niveau d\'un personnage mesure son niveau d\'exp??rience au combat. Les personnages montent en niveau au fur et ?? mesure qu\'ils gagnent de l\'exp??rience et gagne la possibilit?? de gagner des Talents qui les rendent meilleurs dans leur travail de mercenaires.\n\nAu dessus du level 11, les personnages sont des v??t??rans et ne gagneront plus de points de Talent, mais ils continueront de s\'ameliorer."
				}
			];

		case "character-screen.brothers-list.LevelUp":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Monter de niveau"
				},
				{
					id = 2,
					type = "description",
					text = "Ce personnage est mont?? de niveau. Monter ses attributs et s??lectionner un Talent!"
				}
			];
			return result;

		case "character-screen.left-panel-header-module.Dismiss":
			return [
				{
					id = 1,
					type = "title",
					text = "Renvoyer"
				},
				{
					id = 2,
					type = "description",
					text = "Renvoyer ce personnage de votre compagnie pour ??conomiser sur le salaire journalier et faire de la place pour quelqu\'un d\'autre. Les personnages endett??s seront lib??r??s de l\'esclavage et quitteront votre compagnie."
				}
			];

		case "character-screen.right-panel-header-module.InventoryButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Inventaire/Sol"
				},
				{
					id = 2,
					type = "description",
					text = "Afficher l\'inventaire global de votre compagnie de mercenaire, ou voir ce qu\'il y a au sol pour le personnage s??lectionner pendant un combat."
				}
			];

		case "character-screen.right-panel-header-module.PerksButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Talents"
				},
				{
					id = 2,
					type = "description",
					text = "Afficher les Talents du personnage s??lectionn??.\n\nLe nombre entre crochets, s\'il y en a, est le nombre disponible de points de Talents."
				}
			];

		case "character-screen.right-panel-header-module.CloseButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Fermer (ESC)"
				},
				{
					id = 2,
					type = "description",
					text = "Ferme cet Ecran."
				}
			];

		case "character-screen.right-panel-header-module.SortButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Range les objets par type"
				},
				{
					id = 2,
					type = "description",
					text = "Range les objets par type."
				}
			];

		case "character-screen.right-panel-header-module.FilterAllButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtre les objets par type"
				},
				{
					id = 2,
					type = "description",
					text = "Montre tous les objets."
				}
			];

		case "character-screen.right-panel-header-module.FilterWeaponsButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtre les objets par type"
				},
				{
					id = 2,
					type = "description",
					text = "Montre seulement les armes, outils offensifs et les accessoires."
				}
			];

		case "character-screen.right-panel-header-module.FilterArmorButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtre les objets par type"
				},
				{
					id = 2,
					type = "description",
					text = "Montre seulement les armures, casques et boucliers."
				}
			];

		case "character-screen.right-panel-header-module.FilterMiscButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtre les objets par type"
				},
				{
					id = 2,
					type = "description",
					text = "Montre seulements les ressources, nourritures, tr??sors et autres."
				}
			];

		case "character-screen.right-panel-header-module.FilterUsableButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Filtre les objets par type"
				},
				{
					id = 2,
					type = "description",
					text = "Montre seulements les objets utilisables en mode inventaire, comme les peintures ou les am??liorations d\'armures."
				}
			];

		case "character-screen.right-panel-header-module.FilterMoodButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Montre/Cache l\'Humeur"
				},
				{
					id = 2,
					type = "description",
					text = "Bascule entre montrer et cacher l\'humeur de vos hommes."
				}
			];

		case "character-screen.battle-start-footer-module.StartBattleButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Commencer la bataille"
				},
				{
					id = 2,
					type = "description",
					text = "Commencer la bataille en utilisant l\'??quipement s??lectionn??."
				}
			];

		case "character-screen.levelup-popup-dialog.StatIncreasePoints":
			return [
				{
					id = 1,
					type = "title",
					text = "Points d\'attributs"
				},
				{
					id = 2,
					type = "description",
					text = "D??penser ces points pour augmenter 3 des 8 attributs par niveau par un nombre al??atoire. Un attribut peut seulement ??tre augment?? une fois seulement par niveau.\n\nLes ??toiles signifient qu\'un personnage est talentueux dans un attribut sp??cifique, ce qui permet d\'avoir r??guli??rement de meilleures jets de stats."
				}
			];

		case "character-screen.dismiss-popup-dialog.Compensation":
			return [
				{
					id = 1,
					type = "title",
					text = "Compensation"
				},
				{
					id = 2,
					type = "description",
					text = "Payer une compensation, un pourboir ou une pension pour le temps travaill?? dans la compagnie permettra ?? la personne renvoy??e de partir avec honneur et lui permettra de commencer une nouvelle vie, cela emp??chera les autres membres de la compagnie de r??agir avec col??re au renvoie du personnage.\n\nPour les personnages endett??s une indemnit?? leur est pay?? pour leur temps pass??s au sein de la compagnie. Les autres personnages endett??s appr??cieront si vous payez l\'indemnit??, mais ne seront pas non plus en col??re si vous ne le faites pas."
				}
			];

		case "world-screen.topbar.TimePauseButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Pause (Spacebar)"
				},
				{
					id = 2,
					type = "description",
					text = "Mettre le jeu en Pause."
				}
			];

		case "world-screen.topbar.TimeNormalButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Vitesse Normal (1)"
				},
				{
					id = 2,
					type = "description",
					text = "Le jeu s\'??coulera ?? une vitesse normale."
				}
			];

		case "world-screen.topbar.TimeFastButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Vitesse Rapide (2)"
				},
				{
					id = 2,
					type = "description",
					text = "Le jeu s\'??coulera plus rapidement que la normale."
				}
			];

		case "world-screen.topbar.options-module.ActiveContractButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Contrat Actif"
				},
				{
					id = 2,
					type = "description",
					text = "Montre les d??tails de votre contrat actif."
				}
			];

		case "world-screen.topbar.options-module.RelationsButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Afficher les Factions et Relations (R)"
				},
				{
					id = 2,
					type = "description",
					text = "Voir les factions que vous connaissez et votre relation avec eux."
				}
			];

		case "world-screen.topbar.options-module.CenterButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Centrer la cam??ra (Return, Shift)"
				},
				{
					id = 2,
					type = "description",
					text = "Bouger la cam??ra pour la centrer et la faire zoomer sur votre compagnie de mercenaires."
				}
			];

		case "world-screen.topbar.options-module.CameraLockButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Activer le blocage de la cam??ra (X)"
				},
				{
					id = 2,
					type = "description",
					text = "Active ou d??sactive la cam??ra pour toujours ??tre centr?? sur votre compagnie de mercenaires."
				}
			];

		case "world-screen.topbar.options-module.TrackingButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Activer le suivi des empreintes (F)"
				},
				{
					id = 2,
					type = "description",
					text = "Affiche ou cache les empreintes laiss??s par les autres groupes qui sillonnent le monde pour que vous puissez les suivre ou les ??viter plus facilement."
				}
			];

		case "world-screen.topbar.options-module.CampButton":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Camper (T)"
				},
				{
					id = 2,
					type = "description",
					text = "Faire ou d??faire le camp. Pendant que vous camper, le temps passera plus vite et vos hommes se soigneront et r??pareront leur ??quipement plus rapidement. Cependant, vous ??tes aussi plus succeptible d\'??tre victime d\'une attaque surprise."
				}
			];

			if (!this.World.State.isCampingAllowed())
			{
				ret.push({
					id = 9,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Impossible de camper quand vous voyagez avec un autre groupe[/color]"
				});
			}

			return ret;

		case "world-screen.topbar.options-module.PerksButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Retinue (P)"
				},
				{
					id = 2,
					type = "description",
					text = "See your retinue of non-combat followers that grant various advantages outside combat, and upgrade your cart for more inventory space."
				}
			];

		case "world-screen.topbar.options-module.ObituaryButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Carnet de deuil (O)"
				},
				{
					id = 2,
					type = "description",
					text = "Dans le carnet de deuil ayez acc??s ?? la liste de tous vos compagnons qui sont tomb??s au combat depuis que vous ??tes aux commandes."
				}
			];

		case "world-screen.topbar.options-module.QuitButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Ouvrir le Menu (Esc)"
				},
				{
					id = 2,
					type = "description",
					text = "Ouvrir le menu pour sauvegarder ou charger le jeu, ajuster les options du jeu, quitter la campagne ou retourner sur le menu principal."
				}
			];

		case "world-screen.active-contract-panel-module.ToggleVisibilityButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Annuler Contrat"
				},
				{
					id = 2,
					type = "description",
					text = "Annuler le contrat actif."
				}
			];

		case "world-screen.obituary.ColumnName":
			return [
				{
					id = 1,
					type = "title",
					text = "Nom"
				},
				{
					id = 2,
					type = "description",
					text = "Nom du personnage."
				}
			];

		case "world-screen.obituary.ColumnTime":
			return [
				{
					id = 1,
					type = "title",
					text = "Jours"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de jours o?? le personnage a ??t?? dans la compagnie avant son d??c??s."
				}
			];

		case "world-screen.obituary.ColumnBattles":
			return [
				{
					id = 1,
					type = "title",
					text = "Batailles"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombres de batailles dont le personnage a particip?? avant son d??c??s."
				}
			];

		case "world-screen.obituary.ColumnKills":
			return [
				{
					id = 1,
					type = "title",
					text = "Tu??s"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de tu??s que le personnage a accumul?? avant son d??c??s."
				}
			];

		case "world-screen.obituary.ColumnKilledBy":
			return [
				{
					id = 1,
					type = "title",
					text = "D??c??s"
				},
				{
					id = 2,
					type = "description",
					text = "Comment le personnage est mort."
				}
			];

		case "world-town-screen.main-dialog-module.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Quitter"
				},
				{
					id = 2,
					type = "description",
					text = "Quitter et retourner ?? la carte du monde."
				}
			];

		case "world-town-screen.main-dialog-module.Contract":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Contrats disponibles"
				},
				{
					id = 2,
					type = "description",
					text = "Quelqu\'un cherche ?? employer des mercenaires."
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.ContractNegotiated":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Contrats disponibles"
				},
				{
					id = 2,
					type = "description",
					text = "Les termes du contrat ont ??t?? n??goci??s. Tout ce qu\'il vous reste ?? faire c\'est de le signer."
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.ContractDisabled":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Vous avez d??j?? un contrat!"
				},
				{
					id = 2,
					type = "description",
					text = "Vous pouvez avoir seulement un contrat actif ?? un moment donn??. Les offres de contrats resteront pendant que vous effectuez le contrat actuel, ?? moins que le probl??me ne disparaisse d\'ici l??."
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.ContractLocked":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Contrats Bloqu??s"
				},
				{
					id = 2,
					type = "description",
					text = "Seulement les contrats donn??s par les nobles poss??dant cette fortification sont disponibles ici, mais vous n\'??tes pas digne de leur attention. Augmentez votre renom et accomplissez l\'ambition des maisons des nobles pour qu\'il remarque la compagnie et vous confient des contrats!"
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.Crowd":
			return [
				{
					id = 1,
					type = "title",
					text = "Engager"
				},
				{
					id = 2,
					type = "description",
					text = "Engager de nouveaux hommes dans votre compagnie de mercenaires. La qualit?? et la quantit?? de volontaire d??pend de la taille et du type de colonie. Tous les quelques jours, de nouvelles personnes arriveront, et d\'autres partiront."
				}
			];

		case "world-town-screen.main-dialog-module.Tavern":
			return [
				{
					id = 1,
					type = "title",
					text = "Taverne"
				},
				{
					id = 2,
					type = "description",
					text = "Une grande taverne templie de clients des quatres coins du monde, elle offre boissons, nourriture poss??de une atmoph??re vivante dans laquelle il est possible de partager des rumeurs et des informations."
				}
			];

		case "world-town-screen.main-dialog-module.Temple":
			return [
				{
					id = 1,
					type = "title",
					text = "Temple"
				},
				{
					id = 2,
					type = "description",
					text = "Un refuge contre le monde brutal de dehors. Vous pourrez y chercher de l\'aide pour soigner vos bl??ss??s et y prier pour le salut ??ternel de vos ??mes."
				}
			];

		case "world-town-screen.main-dialog-module.VeteransHall":
			return [
				{
					id = 1,
					type = "title",
					text = "Salle d\'entra??nement"
				},
				{
					id = 2,
					type = "description",
					text = "Un lieu de rassemblement pour ceux qui pratiquent une profession de combat. Ayez vos hommes s\'entra??ner ici pour apprendre de guerriers aguerris, pour que vous puissiez les forger plus rapidement en des mercenaires endurcies."
				}
			];

		case "world-town-screen.main-dialog-module.Taxidermist":
			return [
				{
					id = 1,
					type = "title",
					text = "Taxidermiste"
				},
				{
					id = 2,
					type = "description",
					text = "Pour le bon prix un taxidermiste pourra vous cr??er des objets utiles ?? partir de toutes les sortes de troph??es que vous lui ram??nerez."
				}
			];

		case "world-town-screen.main-dialog-module.Kennel":
			return [
				{
					id = 1,
					type = "title",
					text = "Chenil"
				},
				{
					id = 2,
					type = "description",
					text = "Un chenil o?? des chiens fort et rapides sont ??lev??s pour la guerre."
				}
			];

		case "world-town-screen.main-dialog-module.Barber":
			return [
				{
					id = 1,
					type = "title",
					text = "Barbier"
				},
				{
					id = 2,
					type = "description",
					text = "Personnaliser l\'apparence de vos hommes chez le barbier. Ayez leurs cheveux et barbes coup??s ou achet??s des potions douteuse pour leur faire perdre du poids."
				}
			];

		case "world-town-screen.main-dialog-module.Fletcher":
			return [
				{
					id = 1,
					type = "title",
					text = "Fabricant de fl??ches"
				},
				{
					id = 2,
					type = "description",
					text = "Le fabricant de fl??che se sp??cialise dans toutes les sortes d\'armes ?? distance."
				}
			];

		case "world-town-screen.main-dialog-module.Alchemist":
			return [
				{
					id = 1,
					type = "title",
					text = "Alchimiste"
				},
				{
					id = 2,
					type = "description",
					text = "Un alchimiste vous propose des choses exotiques et dangereuses pour de beaux montants."
				}
			];

		case "world-town-screen.main-dialog-module.Arena":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Ar??ne"
				},
				{
					id = 2,
					type = "description",
					text = "L\'ar??ne permet de gagner de l\'or et de la gloire en se battant dans des combats jusqu\'?? la mort, et tout devant les cris du public qui s\'exclame devant les morts les plus atroces et sanglantes."
				}
			];

			if (this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getBuilding("building.arena").isClosed())
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Il n\'y a plus de matches de planifi??s pour aujourd\'hui. Revenez demain!"
				});
			}

			if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getType() != "contract.arena" && this.World.Contracts.getActiveContract().getType() != "contract.arena_tournament")
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Vous ne pouvez combattre dans l\'ar??ne quand vous avez d??j?? un contrat actif"
				});
			}
			else if (this.World.Contracts.getActiveContract() == null && this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().hasSituation("situation.arena_tournament") && this.World.Assets.getStash().getNumberOfEmptySlots() < 5)
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Vous avez besoin d\'au moins 5 emplacements d\'inventaire vide pour participer dans ce tournoi"
				});
			}
			else if (this.World.Contracts.getActiveContract() == null && this.World.Assets.getStash().getNumberOfEmptySlots() < 3)
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Vous avez besoin d\'au moins 3 emplacements d\'inventaire vide pour combattre dans l\'ar??ne"
				});
			}

			return ret;

		case "world-town-screen.main-dialog-module.Port":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Port"
				},
				{
					id = 2,
					type = "description",
					text = "Le port est utilis?? autant par les bateaux de commerce lointain que par les bateaux de p??ches locaux. Vous aurez probablement la possibilit?? de r??server un voyage vers d\'autres parties du continent ici."
				}
			];

			if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getType() == "contract.escort_caravan")
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Vous ne pouvez utiliser le port quand vous devez escorter une caravane"
				});
			}

			return ret;

		case "world-town-screen.main-dialog-module.Marketplace":
			return [
				{
					id = 1,
					type = "title",
					text = "March??"
				},
				{
					id = 2,
					type = "description",
					text = "Le march?? est un lieu anim?? offrant toute sorte de biens produit dans la r??gion. De nouveaux biens sont produits tous les quelques jours et quand des caravanes atteignent cette colonie."
				}
			];

		case "world-town-screen.main-dialog-module.Weaponsmith":
			return [
				{
					id = 1,
					type = "title",
					text = "Forgeron d\'armes"
				},
				{
					id = 2,
					type = "description",
					text = "Le forgeron d\'armes met en ??talage toutes sortes d\'armes de m??l??s cr???? ?? la main. L\'??quipement endommag?? peut y ??tre r??par?? contre une petite compensation."
				}
			];

		case "world-town-screen.main-dialog-module.Armorsmith":
			return [
				{
					id = 1,
					type = "title",
					text = "Forgeron d\'armures"
				},
				{
					id = 2,
					type = "description",
					text = "Le forgeron d\'armure est le bon endroit pour chercher des biens bien fait et une protection durable. L\'??quipement endommag?? peut y ??tre r??par?? contre une petite compensation."
				}
			];

		case "world-town-screen.hire-dialog-module.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Quitter"
				},
				{
					id = 2,
					type = "description",
					text = "Quitter cet ??cran et retourner ?? celui pr??c??dent."
				}
			];

		case "world-town-screen.hire-dialog-module.HireButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Engager une nouvelle recrue"
				},
				{
					id = 2,
					type = "description",
					text = "Engager la recrue s??lectionner pour qu\'elle rejoigne votre compagnie."
				}
			];

		case "world-town-screen.hire-dialog-module.TryoutButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Periode d\'essai pour la recrue"
				},
				{
					id = 2,
					type = "description",
					text = "Donner une periode d\'essai ?? la recrue pour r??v??ler ses traits cach??s, si elle en a."
				}
			];

		case "world-town-screen.hire-dialog-module.UnknownTraits":
			return [
				{
					id = 1,
					type = "title",
					text = "Traits de Personnage Inconnus"
				},
				{
					id = 2,
					type = "description",
					text = "Ce personnage pourrait avoir des traits inconnus. Vous pouvez payer pour les r??v??l??s."
				}
			];

		case "world-town-screen.taxidermist-dialog-module.CraftButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Artisanat"
				},
				{
					id = 2,
					type = "description",
					text = "Payer le prix indiqu??, et fournisser les composants n??cessaires pour recevoir l\'objet fabriqu?? en retour."
				}
			];

		case "world-town-screen.travel-dialog-module.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Quitter"
				},
				{
					id = 2,
					type = "description",
					text = "Quitter cet ??cran et retourner ?? celui pr??c??dent."
				}
			];

		case "world-town-screen.travel-dialog-module.TravelButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Voyager"
				},
				{
					id = 2,
					type = "description",
					text = "R??server le voyage pour que votre compagnie puisse faire un voyage rapide vers la destination selectionn??e."
				}
			];

		case "world-town-screen.shop-dialog-module.LeaveButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Quitter Magasin"
				},
				{
					id = 2,
					type = "description",
					text = "Quitter cet ??cran et retourner ?? celui pr??c??dent."
				}
			];

		case "world-town-screen.training-dialog-module.Train1":
			return [
				{
					id = 1,
					type = "title",
					text = "Combat d\'entra??nement"
				},
				{
					id = 2,
					type = "description",
					text = "Ayez un de vos homme participer ?? une joute amicale contre des combattants exp??riment??s utilisant des styles de combat vari??s. Les bleus re??us et les le??ons appr??ses se traduisent en un gain de [color=" + this.Const.UI.Color.PositiveValue + "]+50%[/color] d\'exp??rience pour la prochaine bataille."
				}
			];

		case "world-town-screen.training-dialog-module.Train2":
			return [
				{
					id = 1,
					type = "title",
					text = "Les le??ons d\'un v??t??ran"
				},
				{
					id = 2,
					type = "description",
					text = "Ayez un de vos homme participer ?? des le??ons et un transferts de connaissances par des v??t??rans du m??tier. La connaissance acquise se traduit par un gain de [color=" + this.Const.UI.Color.PositiveValue + "]+35%[/color] d\'exp??rience pour les trois prochaines batailles."
				}
			];

		case "world-town-screen.training-dialog-module.Train3":
			return [
				{
					id = 1,
					type = "title",
					text = "Enseignement Rigoureux"
				},
				{
					id = 2,
					type = "description",
					text = "Ayez un de vos homme participer ?? un entraiment rigoureux de r??giment pour le fa??onner en un combatant exp??riment??. Le sang et les larmes vers??s lui seront b??n??fiques et se traduisent sur le long terme par un gain de [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] d\'exp??rience pour les cinq prochaines batailles."
				}
			];

		case "world-game-finish-screen.dialog-module.QuitButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Quiter le jeu"
				},
				{
					id = 2,
					type = "description",
					text = "Quitter le jeu et retourner au menu principal. Votre progr??s ne sera pas sauvegard??."
				}
			];

		case "world-relations-screen.Relations":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Relations"
				},
				{
					id = 2,
					type = "description",
					text = "Vos relations avec une faction d??termine si elle vous combattront ou agiront pacifiquement envers vous, leur volont?? de vous engager pour des contrats, le prix qu\'ils seront pr??t ?? vous payer ainsi que le nombre de recrues qui vous seront accessible dans leur colonies.\n\nLes relations augmentent en menant un bien des contract pour les factions, et diminuent quand vous ??chouez, quand vous les trahissez ou quand vous les attaquez. Au fur et ?? mesure que le temps d\'??coule, les relations se dirige vers la neutralit??."
				}
			];
			local changes = this.World.FactionManager.getFaction(_entityId).getPlayerRelationChanges();

			foreach( change in changes )
			{
				if (change.Positive)
				{
					ret.push({
						id = 11,
						type = "hint",
						icon = "ui/tooltips/positive.png",
						text = "" + change.Text + ""
					});
				}
				else
				{
					ret.push({
						id = 11,
						type = "hint",
						icon = "ui/tooltips/negative.png",
						text = "" + change.Text + ""
					});
				}
			}

			return ret;

		case "world-campfire-screen.Cart":
			local ret = [
				{
					id = 1,
					type = "title",
					text = this.Const.Strings.InventoryHeader[this.World.Retinue.getInventoryUpgrades()]
				},
				{
					id = 2,
					type = "description",
					text = "Une compagnie de mercenaire transporte ??normement d\'??quipement et de ressources. En utilisant des chariots et des carriages, vous pouvez agrandir l\'espace d\'inventaire disponible et vous pourrez donc transporter encore plus."
				}
			];

			if (this.World.Retinue.getInventoryUpgrades() < this.Const.Strings.InventoryUpgradeHeader.len())
			{
				ret.push({
					id = 1,
					type = "hint",
					icon = "ui/icons/mouse_left_button.png",
					text = this.Const.Strings.InventoryUpgradeHeader[this.World.Retinue.getInventoryUpgrades()] + " for [img]gfx/ui/tooltips/money.png[/img]" + this.Const.Strings.InventoryUpgradeCosts[this.World.Retinue.getInventoryUpgrades()]
				});
			}

			return ret;

		case "dlc_1":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Lindwurm"
				},
				{
					id = 2,
					type = "description",
					text = "The free Lindwurm DLC adds a challenging new beast, a new player banner, as well as a new famed armor, helmet and shield."
				}
			];

			if (this.Const.DLC.Lindwurm == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]This DLC has been installed.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]This DLC is missing. It\'s available for free on Steam and GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Open store page in browser"
			});
			return ret;

		case "dlc_2":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Beasts & Exploration"
				},
				{
					id = 2,
					type = "description",
					text = "The Beasts & Exploration DLC adds a variety of new beasts roaming the wilds, a new crafting system to create items from trophies, legendary locations with unique rewards to discover, many new contracts and events, a new system of armor attachments, new weapons, armor and usable items, and more."
				}
			];

			if (this.Const.DLC.Unhold == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]This DLC has been installed.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]This DLC is missing. It\'s available for purchase on Steam and GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Open store page in browser"
			});
			return ret;

		case "dlc_4":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Warriors of the North"
				},
				{
					id = 2,
					type = "description",
					text = "The Warriors of the North DLC adds a new human faction of northern barbarians with their own fighting style and equipment, different starting scenarios for your company, new nordic and rus inspired equipment, as well as new contracts and events."
				}
			];

			if (this.Const.DLC.Wildmen == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]This DLC has been installed.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]This DLC is missing. It\'s available for purchase on Steam and GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Open store page in browser"
			});
			return ret;

		case "dlc_6":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Blazing Deserts"
				},
				{
					id = 2,
					type = "description",
					text = "The Blazing Deserts DLC adds a new desert region to the south inspired by medieval Arabic and Persian cultures, a new late game crisis involving a holy war, a retinue of non-combat followers with which to customize your company, alchemical contraptions and primitive firearms, new human and beastly opponents, new contracts and events, and more."
				}
			];

			if (this.Const.DLC.Desert == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]This DLC has been installed.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]This DLC is missing. It\'s available for purchase on Steam and GOG![/color]";
			}
			
			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Open store page in browser"
			});
			return ret;

		case "dlc_8":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Of Flesh and Faith"
				},
				{
					id = 2,
					type = "description",
					text = "The free Of Flesh and Faith DLC adds two new and very unique origins for you to play as: The Anatomists and the Oathtakers. In addition, there\'s two new banners, new equipment, new backgrounds to hire and lots of new events."
				}
			];

			if (this.Const.DLC.Paladins == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]This DLC has been installed.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]This DLC is missing. It\'s available for free on Steam and GOG![/color]";
			}


			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Open store page in browser"
			});
			return ret;
		}

		return null;
	}

};

