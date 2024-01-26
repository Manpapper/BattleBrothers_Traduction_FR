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
					text = "Siège verrouillé"
				},
				{
					id = 4,
					type = "description",
					text = "Votre compagnie manque de renom néceessaire pour employer plus de non-combatant. Atteignez au moins " + renown + " de renom pour débloquer cet emplacement. Gagnez du renom en complétant des ambitions, des contrats et aussi en gagnant des batailles."
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
					text = "Ouvrir l\'écran de recrutement"
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
					text = lastTileHovered.Properties.get("Corpse").CorpseName + " a été tué ici."
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
							text = "Le déplacement vous coûtera [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getActionPointCosts()[lastTileHovered.Type] + "+" + actor.getLevelActionPointCost() + "[/color][/b] AP et [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getFatigueCosts()[lastTileHovered.Type] + "+" + actor.getLevelFatigueCost() + "[/color][/b] Fatigue car ce n\'est pas à la même hauteur"
						});
					}
					else
					{
						tooltipContent.push({
							id = 90,
							type = "text",
							text = "Le déplacement vous coûtera [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getActionPointCosts()[lastTileHovered.Type] + "[/color][/b] PA et [b][color=" + this.Const.UI.Color.PositiveValue + "]" + actor.getFatigueCosts()[lastTileHovered.Type] + "[/color][/b] Fatigue"
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
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]Cache n\'importe qui s\'y cachant tant qu\'il n\'y a personne à proximité.[/color]"
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
					text = "[color=" + this.Const.UI.Color.NegativeValue + "] Est dans la zone de contrôle de l\'ennemi.[/color]"
				});
			}

			if (lastTileHovered.IsVisibleForPlayer && (lastTileHovered.SquareCoords.X == 0 || lastTileHovered.SquareCoords.Y == 0 || lastTileHovered.SquareCoords.X == 31 || lastTileHovered.SquareCoords.Y == 31))
			{
				tooltipContent.push({
					id = 99,
					type = "text",
					icon = "ui/tooltips/warning.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]N\'importe quel personnage sur ce carreau peut partir sans encombre et immédiatement de la bataille.[/color]"
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
					text = _item.isToBeRepaired() ? "Retirer le marquage de réparation de l\'objet" : "Marquer l\'objet pour qu\'il soit réparé"
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
						text = "Payer [img]gfx/ui/tooltips/money.png[/img]" + price + " pour le réparer"
					});
				}
				else
				{
					tooltip.push({
						id = 3,
						type = "hint",
						icon = "ui/tooltips/warning.png",
						text = "Pas assez de couronnes pour payer les réparations!"
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
						text = "Rapports de votre observateur"
					}
				];

				for( local i = 1; i < footprints.len(); i = ++i )
				{
					if (footprints[i])
					{
						ret.push({
							id = 1,
							type = "hint",
							text = this.Const.Strings.FootprintsType[i] + " est passé récemment par ici"
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
							text = "Disponible, mais ce personnage n\'a pas de point d\'aptitude à dépenser"
						});
					}
				}
				else if (perk.Unlocks - player.getPerkPointsSpent() > 1)
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = "Bloqué tant que " + (perk.Unlocks - player.getPerkPointsSpent()) + " points d\'aptitude n\'ont pas été dépensés"
					});
				}
				else
				{
					ret.push({
						id = 3,
						type = "hint",
						icon = "ui/icons/icon_locked.png",
						text = "Bloqué tant que " + (perk.Unlocks - player.getPerkPointsSpent()) + " points d\'aptitude n\'ont pas été dépensés"
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
						text = "Le nombre de pièces que votre compagnie possède. Utilisé pour payer tous vos hommes à midi, ainsi qu\'à engager de nouvelles personnes ou acheter du nouvel equipement.\n\nVous ne payez actuellement personne."
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
						text = "Le nombre de pièces que votre compagnie possède. Utilisé pour payer tous vos hommes à midi, ainsi qu\'à engager de nouvelles personnes ou acheter du nouvel equipement.\n\nVous payez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyMoney + "[/color] couronnes par jour. Vos [color=" + this.Const.UI.Color.PositiveValue + "]" + money + "[/color] couronnes dureront encore [color=" + this.Const.UI.Color.PositiveValue + "]" + time + "[/color] jour."
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
						text = "Le nombre de pièces votre compagnie possède. Utilisé pour payer tous vos hommes à midi, ainsi qu\'à engager de nouvelles personnes ou acheter du nouvel equipement.\n\nVous payez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyMoney + "[/color] couronnes par jour.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Vous n\'avez plus de couronnes pour payer vos hommes! Gagnez rapidement des couronnes ou vos hommes s\'en iront un par un.[/color]"
					}
				];
			}

		case "assets.InitialMoney":
			return [
				{
					id = 1,
					type = "title",
					text = "Coût d\'embauche"
				},
				{
					id = 2,
					type = "description",
					text = "Le coût d\'embauche sera payé immédiatement en engagant un homme, pour lui prouver que vous pouvez appuyer vos mots avec des pièces."
				}
			];

		case "assets.Fee":
			return [
				{
					id = 1,
					type = "title",
					text = "Coût d\'embauche"
				},
				{
					id = 2,
					type = "description",
					text = "Ce coût sera payé d\'avance pour les services qui seront rendus."
				}
			];

		case "assets.TryoutMoney":
			return [
				{
					id = 1,
					type = "title",
					text = "Coût d\'essai"
				},
				{
					id = 2,
					type = "description",
					text = "Ce paiement permet de connaître la recrue, ce qui révelera ses traits (s\'il en possède)."
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
					text = "Ce salaire sera payé tous les jours pour servir sous vos ordres. Ce salaire est augmenté automatiquement de 10% par level jusqu\'au level 11, puis 3% ensuite."
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
						text = "Le total de provisions que vous portez. Un homme normal a besoin de 2 provisions par jour et plus surdes terrain accidentés. Vos hommes prioriserons les denrés qui sont proches de l\'expiration. Arriver à cours de provisions diminuera le moral et fera fuir vos hommes avant de mourir de faim.\n\nVous utilisez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color] provisions par jour. Vos [color=" + this.Const.UI.Color.PositiveValue + "]" + food + "[/color] provisions vous permettrons de tenir encore [color=" + this.Const.UI.Color.PositiveValue + "]" + time + "[/color] jours tout au plus. Gardez à l\'esprit que certaines provisions peuvent pourrir!"
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
						text = "Le total de provisions que vous portez. Un homme normal a besoin de 2 provisions par jour et plus sur des terrains accidentés. Vos hommes prioriserons les denrés qui sont proches de l\'expiration. Arriver à cours de provisions diminuera le moral et fera fuir vos hommes avant de mourir de faim.\n\nVous utilisez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color] provisions par jour.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Vous n\'avez pratiquement plus de provisions pour nourrir vos hommes! Achetez rapidement des provisions aussi vite que possible ou vos hommes déserterons un par un avant de mourrir de faim![/color]"
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
						text = "Le total de provisions que vous portez. Un homme normal a besoin de 2 provisions par jour et plus  sur des terrains accidentés. Vos hommes prioriserons les denrées qui sont proches de l\'expiration. Arriver à cours de provisions diminuera le moral et fera fuir vos hommes avant de mourir de faim.\n\nVous utilisez [color=" + this.Const.UI.Color.PositiveValue + "]" + dailyFood + "[/color] provisions par jour.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Vous n\'avez plus de provisions pour nourrir vos hommes! Achetez rapidement des provisions aussi vite que possible ou vos hommes déserterons un par un avant de mourrir de faim![/color]"
					}
				];
			}

		case "assets.DailyFood":
			return [
				{
					id = 1,
					type = "title",
					text = "Provisions journalières"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de provision qu\'un homme à besoin par jour. Arriver à cours de provisions diminuera le moral et fera fuir vos hommes avant de mourir de faim."
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
					text = "Un ensemble de flèches, carreau et d\'armes de jets utilisés automatiquement pour remplir les carquois après les batailles. Remplacer une flèche ou un carreau utilisera une munition, remplacer un tir d\'arme à main utilisera jusqu\'à deux points et remplacer une arme de jet ou une charge de lance de feu en utilisera jusqu\'à trois. Arriver à court de munition laissera votre carquoi vide et vos hommes n\'auront plus rien à tirer. Vous ne pouvez porter plus de " + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].Ammo + this.World.Assets.m.AmmoMaxAdditional) + " munitions."
				}
			];

		case "assets.Supplies":
			local repair = this.World.Assets.getRepairRequired();
			local desc = "Ensemble d\'outils et de ressources pour garder vos armes, armures, casques et boucliers en bonne condition. Un point est nécessaire pour réparer 15 points de durabilité d\'un objet. Arriver à court d\'outils peut signifier que vos armes peuvent se casser durant un combat ou laisser vos armures en mauvaise condition et donc inutiles.";

			if (repair.ArmorParts > 0)
			{
				desc = desc + ("\n\nRéparer tous vos équipements durera [color=" + this.Const.UI.Color.PositiveValue + "]" + repair.Hours + "[/color] heures et nécessitera ");

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
			local desc = "Les ressources médicales comportent des bandages, des herbes, des onguents et autres fournitures de la sorte, ils sont utilisés pour soigner les blessures graves de vos hommes après un combat. Une unité de ressource médicale est requise tous les jours pour chaque blessure pour les soigner jusqu\'à la guérison complète. Les points de vies perdus se soignent d\'eux-mêmes.\n\nArriver à court de ressource médicale empêchera vos hommes de récupérer de leurs blessures.";

			if (heal.MedicineMin > 0)
			{
				desc = desc + ("\n\nSoigner vos hommes prendra entre [color=" + this.Const.UI.Color.PositiveValue + "]" + heal.DaysMin + "[/color] et [color=" + this.Const.UI.Color.PositiveValue + "]" + heal.DaysMax + "[/color] jours et nécessitera entre ");

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

				desc = desc + (heal.MedicineMax + "[/color] ressources médicales.");
			}

			desc = desc + (" Vous pouvez porter " + (this.Const.Difficulty.MaxResources[this.World.Assets.getEconomicDifficulty()].Medicine + this.World.Assets.m.MedicineMaxAdditional) + " ressources médicales au maximum.");
			return [
				{
					id = 1,
					type = "title",
					text = "Ressources Médicales"
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
					text = "Montre l\'ensemble des informations relatives à votre compagnie de mercenaire."
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
					text = "Le renom est votre réputation en tant que mercenaire professionnel et reflète à quel point les gens vous juge fiable et compétent. Le plus haut votre renom, le plus haut sera la récompense et la difficulté des contrats qui vous seront proposés. Le renom augmentera en réussissant vos ambitions, vos contrats et en gagnants vos batailles, et diminuera en n\'arrivant pas à les faire."
				}
			];

		case "assets.MoralReputation":
			return [
				{
					id = 1,
					type = "title",
					text = "Réputation: " + this.World.Assets.getMoralReputationAsText()
				},
				{
					id = 2,
					type = "description",
					text = "Votre réputation reflète comment les gens dans le monde juge la conduite de votre compagnie de mercenaire en se basant sur vos actions passés. Avez-vous épargné vos ennemies ? Est-ce que vous brûler les fermes et tuer la paysannerie? En se basant sur votre réputation, les gens vous offrirons différents types de contrats, de plus les contrats et les évenements pourraient se finir différement."
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
						text = "Vous n\'avez pas annoncé d\'ambition pour votre compagnie. Cela vous le sera demandé au fur et à mesure que le jeu progressera."
					}
				];
			}

		case "stash.FreeSlots":
			return [
				{
					id = 1,
					type = "title",
					text = "Capacité"
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
					text = "Montre le nombre actuel et maximum d\'hommes placés en formatoin pour se battre dans la prochaine bataille.\n\nGlisser et déposer vos hommes où vous voulez qu\'ils soient; La ligne du haut est la ligne de front façant l\'ennemi, la seconde ligne est la ligne à l\'arrière, et la ligne du bas est la ligne de réserve (vos hommes qui ne prendront pas part au combat)."
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
					text = "Les Points d\'Action (PA) sont utilisés pour chaque action, comme bouger ou utiliser une capacité. Une fois que tous les points sont utilisés, le personnage actuel terminera son tour automatiquement. Les PA sont restaurés au début de chaque tour."
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
					text = "Les points de vie représentent les dommages qu\'un personnage peut prendre avant de mourrir. Une fois qu\'ils atteignent zéro, le personnage est considéré mort. Plus les point de vies sont élevés, moins le caractère à de \"chance\" de subir une blessure incapacitante quand il est touché."
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
					text = "Le moral est un des cinq état qui représente la condition mentale de vos combatants ainsi que leur efficacité en combat. Au plus bas, ils fuiront, le personnage sera alors hors de contrôle - même s\'ils se rallieront probablement de nouveau. Le Moral change au fur et à mesure que la bataille progresse, avec des personnages ayant un moral assez haut, ils auront moins tendence à tomber dans un moral bas (et donc à fuir). Beaucoup de vos ennemies sont aussi affectés par le moral.\n\nDes vérifications de moral sont lancés à ces différentes occasions:\n- Tuer un ennemi\n- Voir un ennemi être tué\n- Voir un allié être tué\n- Voir un allié fuir\n- Etre touché et subir plus de 15 point de vie de dégâts\n- Etre engagé en mélée par plus d\'un ennemi\n- Utiliser certaines compétences, comme \'Rallier\'"
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
					text = "La Fatigue est gagné pour chaque action, comme bouger, utiliser une compétence, en se faisant toucher en combat ou encore en esquivant. La Fatigue est reduite de 15 à chaque tour ou autant qu\'il est nécessaire pour qu\'un personnage commence son tour avec son mximum de fatigue moins 15. Si un personnage accumule trop de fatigue, il aura probablement besoin de se reposer pendant un ou plusieurs tours (en ne faisant rien) avant d\'avoir la possibilité d\'utiliser des capacités plus spécialisés."
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
					text = "La Fatigue Maximum est la Fatigue maximum qu\'un personnage peut accumuler avant d\'être dans l\'impossibilité d\'effectuer plus d\'actions. Elle est réduite en portant des équipements lourds, spécifiquement les armures."
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
					text = "Le casque (armure) protège, étonnament, la tête, qui est plus difficile à toucher que le corps, mais qui est plus vulnérable aux dégats. Plus vous avez de l\'armure (casque), moins il y aura de dégats appliqués à vos points de vies si vous vous faites toucher à la tête."
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
					text = "Plus vous avez de l\armure (corps) moins il y aura de dégats appliqués à vos points de vies si vous vous faites toucher."
				}
			];

		case "character-stats.MeleeSkill":
			return [
				{
					id = 1,
					type = "title",
					text = "Maîtrise de Mêlée"
				},
				{
					id = 2,
					type = "description",
					text = "Elle détermine la probabilité de base de toucher une cible avec une attaque de mêlée, tel que les épées et les lances. Elle peut être augmentée quand le personnage gagne des niveaux."
				}
			];

		case "character-stats.RangeSkill":
			return [
				{
					id = 1,
					type = "title",
					text = "Maîtrise à distance"
				},
				{
					id = 2,
					type = "description",
					text = "Elle détermine la probabilité de base de toucher une cible avec une attaque à distance, tel que les arcs ou les arbalètes. Elle peut être augmentée quand le personnage gagne des niveaux."
				}
			];

		case "character-stats.MeleeDefense":
			return [
				{
					id = 1,
					type = "title",
					text = "Défense de Mêlée"
				},
				{
					id = 2,
					type = "description",
					text = "Une défense de mêlée plus élevée réduit la probabilité de se faire toucher par une attaque de mêlée, tel que les coups de lances. Elle peut être augmentée quand le personnage gagne des niveaux ou en équippant un bon bouclier."
				}
			];

		case "character-stats.RangeDefense":
			return [
				{
					id = 1,
					type = "title",
					text = "Défense à Distance"
				},
				{
					id = 2,
					type = "description",
					text = "Une défense à distance plus élevée réduit la probabilité de se faire toucher par une attaque à distance, tel qu\'une flèche tiré d\'une certaine distance. Elle peut être augmentée quand le personnage gagne des niveaux ou en équippant un bon bouclier."
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
					text = "La Vision, ou la distance de vue, détermine la distance à laquel un personnage peut voir et donc révéler ce qu\'il y a derrière le brouillard de guerre, découvrir des menaces ou encore tirer avec des attaques à distance. Les casques lourd et la nuit peuvent la faire diminuer."
				}
			];

		case "character-stats.RegularDamage":
			return [
				{
					id = 1,
					type = "title",
					text = "Dégâts"
				},
				{
					id = 2,
					type = "description",
					text = "Les dégâts de base que fait l\'arme actuellement équipé. Sera appliqué entièrement s\'il n\'y a pas d\'armure protégeant la cible. Si la cible est protégé par l\'armure, les dégâts sont appliqués à l\'armure en se basant sur l\'efficacité de l\'arme contre l\'armure. Les dégâts occasionnés sont modifiés par la compétence utilisé et la cible touché."
				}
			];

		case "character-stats.CrushingDamage":
			return [
				{
					id = 1,
					type = "title",
					text = "Efficacité contre l\'Armure"
				},
				{
					id = 2,
					type = "description",
					text = "Le pourcentage des dégats de base de l\'arme quand elle frappe une cible en armure. Dès que l\'armure est détruite, les dégâts de l\'arme sont appliqués à 100%. Les dégâts occasionnés sont modifiés par la compétence utilisé et la cible touché."
				}
			];

		case "character-stats.ChanceToHitHead":
			return [
				{
					id = 1,
					type = "title",
					text = "Chance de toucher la tête"
				},
				{
					id = 2,
					type = "description",
					text = "La probabilité de base de toucher la tête de la cible pour des dégats augmentés. La probabilité finale peut être modifiés par la compétence utilisé."
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
					text = "Plus la valeur est élevée, plus le personnage commencera son tour tôt. L\'Initiative est réduite par la fatigue actuelle, ainsi que toute pénalité appliqué à la Fatigue Maximum (comme les amures lourdes). En général, quelqu\'un en armure légère jouera son tour avant quelqu\'un en armure lourde, et quelqu\'un en pleine forme jouera avant quelqu\'un de fatigué."
				}
			];

		case "character-stats.Bravery":
			return [
				{
					id = 1,
					type = "title",
					text = "Détermination"
				},
				{
					id = 2,
					type = "description",
					text = "La Détermination répresente la volonté et la bravoure de vos personnages. Plus elle est élevée, moins vos personnages auront la probabilité de faire descendre le moral pendant des événements négatifs, et plus vos personnages auront la chance de gagner en confidence lors des événements positifs. La détermination acte comme une défense contre les attaques mentales qui infligent des paniques, la peur, ou des contrôles mentale. Voir aussi: Moral."
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
					text = "Niveau Supérieur"
				},
				{
					id = 2,
					type = "description",
					 text = "Ce personnage a déjà de l'expérience au combat et démarre avec un niveau plus élevé."
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
					text = "Charger la campagne sélectionnée."
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
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]WARNING:[/color] Supprime la campagne sélectionnée sans d\'autres avertissements."
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
					text = "Sauvegarder la campagne à l\'emplacement selectionné."
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
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]WARNING:[/color] Supprime la campagne sélectionnée sans d\'autres avertissements."
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
					text = "Graine de Carte"
				},
				{
					id = 2,
					type = "description",
					 text = "Une graine de carte est une chaîne unique qui détermine l'apparence du monde dans votre campagne. Vous pouvez voir la graine des campagnes en cours dans le menu du jeu accessible en appuyant sur la touche Échap, puis la partager avec des amis pour qu'ils jouent dans le même monde."
				}
			];

		case "menu-screen.new-campaign.EasyDifficulty":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficulté Débutant"
				},
				{
					id = 2,
					type = "description",
					text = "Vous ferez fasse à moins d\'ennemi, et ils seront plus facile, vos hommes gagneront de l\'expérience plus rapidement et battre en retraite pendant les bataille est plus facile.\n\nVos hommes auront un petit bonus aux chances de toucher et les ennemis une petite pénalité, pour faciliter votre arrivé dans le jeu.\n\nRecommendé pour les nouveaux joueurs."
				}
			];

		case "menu-screen.new-campaign.NormalDifficulty":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficulté Vétéran"
				},
				{
					id = 2,
					type = "description",
					text = "Fournit une expérience plus équilibré qui peut se révéler plus difficile.\n\nRecommendé pour les vétérans du jeu ou du genre."
				}
			];

		case "menu-screen.new-campaign.HardDifficulty":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficulté Expert"
				},
				{
					id = 2,
					type = "description",
					text = "Vos rencontres seront plus difficiles et nombreuses.\n\nRecommendé pour les experts du jeu qui veulent un défi mortel."
				}
			];

		case "menu-screen.new-campaign.EasyDifficultyEconomic":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficulté Débutant"
				},
				{
					id = 2,
					type = "description",
					text = "Les contrats paieront plus, vous pourrez transporter plus de ressources.\n\nRecommendé pour les nouveaux joueurs."
				}
			];

		case "menu-screen.new-campaign.NormalDifficultyEconomic":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficulté Veteran"
				},
				{
					id = 2,
					type = "description",
					text = "Fournit une expérience plus équilibré qui peut se révéler plus difficile.\n\nRecommendé pour les vétérans du jeu ou du genre."
				}
			];

		case "menu-screen.new-campaign.HardDifficultyEconomic":
			return [
				{
					id = 1,
					type = "title",
					text = "Difficulté Expert"
				},
				{
					id = 2,
					type = "description",
					text = "Les contrats paieront moins, les deserteurs prendront leur équipement avec eux.\n\nRecommendé pour les experts du jeu qui veulent plus de défi à gérer les fonds et les ressources de la compagnie."
				}
			];

		case "menu-screen.new-campaign.EasyDifficultyBudget":
			return [
				{
					id = 1,
					type = "title",
					text = "Fonds de départ - Elevé"
				},
				{
					id = 2,
					type = "description",
					text = "Vous commencerez avec plus de couronnes et de ressources.\n\nRecommendé pour les nouveaux joueurs."
				}
			];

		case "menu-screen.new-campaign.NormalDifficultyBudget":
			return [
				{
					id = 1,
					type = "title",
					text = "Fonds de départ - Moyen"
				},
				{
					id = 2,
					type = "description",
					text = "Recommendé pour une expérience équilibré."
				}
			];

		case "menu-screen.new-campaign.HardDifficultyBudget":
			return [
				{
					id = 1,
					type = "title",
					text = "Fonds de départ - Bas"
				},
				{
					id = 2,
					type = "description",
					text = "Vous commencerez avec moins de couronnes et de ressources.\n\nRecommendé pour les experts du jeu."
				}
			];

		case "menu-screen.new-campaign.StartingScenario":
			return [
				{
					id = 1,
					type = "title",
					text = "Scénario de Départ"
				},
				{
					id = 2,
					type = "description",
					text = "Choisissez comment commence votre compagnie dans le monde. En fonction de votre choix, vous commencerez avec différents hommes, équipement, ressources et des règles spéciales."
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
					text = "Le mode Ironman désactive les sauvegardes manuelles. Une seule sauvegarde existera pour la compagnie, et le jeu est sauvegardé automatiquement durant le jeu et en quittant. Perdre la compagnie signifie perdre la sauvegarde. Recommendé pour la meilleure expérience une fois que vous connaissez le jeu.\n\nGardez à l\'esprit que les ordinateurs moins puissants pauseront probablement le jeu pendant quelques secondes pour sauvegarder."
				}
			];

		case "menu-screen.new-campaign.Exploration":
			return [
				{
					id = 1,
					type = "title",
					text = "Carte Inexplorée"
				},
				{
					id = 2,
					type = "description",
					text = "Une façon facultative de jouer au jeu où la carte est entièrement inexplorée et n'est pas visible au début de votre campagne. Vous devrez tout découvrir par vous-même, ce qui rend votre campagne plus difficile, mais potentiellement aussi plus excitante.\n\nRecommandé uniquement pour les joueurs expérimentés qui savent ce qu'ils font."
				}
			];

		case "menu-screen.new-campaign.EvilRandom":
			return [
				{
					id = 1,
					type = "title",
					text = "Crise de fin de jeu Aléatoire"
				},
				{
					id = 2,
					type = "description",
					text = "Une crise sera choisie aléatoirement dans la liste ci-dessous."
				}
			];

		case "menu-screen.new-campaign.EvilNone":
			return [
				{
					id = 1,
					type = "title",
					text = "Pas de Crise"
				},
				{
					id = 2,
					type = "description",
					text = "Il n\'y aura pas de crise de fin de jeu et vous pourrez continuer de jouer indéfiniment. Notez qu\'en sélectionnant cette option, une partie significative du contenu du jeu et du challenge de fin ne sera pas disponible. Pas recommendé pour une bonne expérience de jeu."
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
					text = "Les villes, villages et châteaux peuvent être détruit indéfiniment pendant les crises de fin de jeu, et avoir le monde partir en fumée est une des nombreuses façon de perdre la campagne."
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
					text = "La première crise de fin sera une guerre sans merci entre les maisons des nobles pour le pouvoir. Si vous survivez assez longtemps, les prochaines crises seront choisi aléatoirement."
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
					text = "La première crise de fin sera une invasion de hordes de Peaux-Vertes menaçant de raser le monde des hommes. Si vous survivez assez longtemps, les prochaines crises seront choisi aléatoirement."
				}
			];

		case "menu-screen.new-campaign.EvilUndead":
			return [
				{
					id = 1,
					type = "title",
					text = "Fléau des Morts-Vivant"
				},
				{
					id = 2,
					type = "description",
					text = "Dans la première crise de fin les morts se lèveront de nouveau pour reprendre ce qui leur appartenait autrefois. Si vous survivez assez longtemps, les prochaines crises seront choisi aléatoirement."
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
					text = "La première crise de fin sera une guerre sainte entre les cultures du nord et du sud. Si vous survivez assez longtemps, les prochaines crises seront choisi aléatoirement."
				}
			];

		case "menu-screen.options.DepthOfField":
			return [
				{
					id = 1,
					type = "title",
					text = "Profondeur de Champ"
				},
				{
					id = 2,
					type = "description",
					text = "Activer l'effet de profondeur de champ rendra légèrement floues les hauteurs sous la caméra en combat tactique (c'est-à-dire floues), donnant plus une ambiance de miniature et facilitant la différenciation des hauteurs, mais potentiellement au détriment de certains détails."
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
					 text = "Changez l'échelle de l'interface utilisateur, c'est-à-dire des menus et du texte."
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
					 text = "Changez l'échelle de la scène, c'est-à-dire tout ce qui n'est pas l'interface utilisateur, comme les personnages affichés sur le champ de bataille."
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
					 text = "Glisser avec la souris"
				},
				{
					id = 2,
					type = "description",
					text = "Faites défiler l'écran en maintenant enfoncé le bouton gauche de la souris et en le faisant glisser (par défaut)."
				}
			];

		case "menu-screen.options.HardwareMouse":
			return [
				{
					id = 1,
					type = "title",
					text = "Utiliser le curseur matériel"
				},
				{
					id = 2,
					type = "description",
					 text = "L'utilisation du curseur matériel réduit au minimum le décalage d'entrée lors du déplacement de la souris dans le jeu. Désactivez cela si vous rencontrez des problèmes avec le curseur de la souris."
				}
			];

		case "menu-screen.options.HardwareSound":
			return [
				{
					id = 1,
					type = "title",
					text = "Utiliser le son matériel"
				},
				{
					id = 2,
					type = "description",
					 text = "Utilisez la lecture du son accélérée par matériel pour de meilleures performances. Désactivez cela si vous rencontrez des problèmes liés au son."
				}
			];

		case "menu-screen.options.CameraFollow":
			return [
				{
					id = 1,
					type = "title",
					text = "Centrer toujours sur le mouvement de l'IA"
				},
				{
					id = 2,
					type = "description",
					text = "Ayez toujours la caméra centrée sur tout mouvement de l'IA visible pour vous."
				}
			];

		case "menu-screen.options.CameraAdjust":
			return [
				{
					id = 1,
					type = "title",
					text = "Ajustement automatique des niveaux de hauteur"
				},
				{
					id = 2,
					type = "description",
					text = "Ajustez automatiquement le niveau de hauteur de la caméra pour voir le personnage actuellement actif en combat. La désactivation de cette option empêchera la caméra de changer de niveau de hauteur lorsqu'elle ne sera pas strictement nécessaire, mais nécessitera également un ajustement manuel des niveaux de hauteur lorsque les personnages seront obstrués par le terrain."
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
					text = "Affiche toujours les barres de point de vie et d\'armure au dessus des personnages en combat, par défaut ils sont seulement affichés quand le personnage est touché."
				}
			];

		case "menu-screen.options.OrientationOverlays":
			return [
				{
					id = 1,
					type = "title",
					text = "Afficher les icônes d'orientation"
				},
				{
					id = 2,
					type = "description",
					text = "Affiche des icônes aux bords de votre écran indiquant la direction dans laquelle se trouvent actuellement les personnages à l'extérieur de l'écran sur la carte."
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
					text = "Augmente la vitesse de déplacement des personnages contrôlés par le joueur en combat. N\'affecte pas les compétence liés au déplacement."
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
					text = "Augmente la vitesse de déplacement des personnages contrôlés par l\'IA en combat. N\'affecte pas les compétence liés au déplacement."
				}
			];

		case "menu-screen.options.AutoLoot":
			return [
				{
					id = 1,
					type = "title",
					text = "Récolte butin automatique"
				},
				{
					id = 2,
					type = "description",
					text = "Récupère toujours et automatiquement la récolte du butin après un combat quand vous fermez la page du butin - du moment que vous avez de l\'espace dans votre inventaire."
				}
			];

		case "menu-screen.options.RestoreEquipment":
			return [
				{
					id = 1,
					type = "title",
					text = "Restaure l\'équipement après la Bataille"
				},
				{
					id = 2,
					type = "description",
					text = "Remplace automatiquement l\'équipement dans l\'inventaire tel qu\'il l\'était avant le combat, si possible. Par exemple, si un personnage commence une bataille avec une arbalète, mais change pour une pique au cours du combat, ils auront automatiquement l\'arbalète en main quand la bataille est terminée."
				}
			];

		case "menu-screen.options.AutoPauseAfterCity":
			return [
				{
					id = 1,
					type = "title",
					text = "Pause-Auto après avoir quitter une Ville"
				},
				{
					id = 2,
					type = "description",
					text = "Met le jeu automatiquement en pause après avoir quitté la ville, cela afin de ne pas perdre de temps - mais oblige d\'enlever la pause à chaque fois."
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
					text = "Affiche toujours le haut des arbres ou autres gros objets en semi-transparent, plutôt que seulement quand ils cachent quelque chose."
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
					text = "Termine automatiquement le tour des personnagess que vous contrôlez dès que vous n\'avez assez de Points d\'Action pour faire une action."
				}
			];

		case "tactical-screen.topbar.event-log-module.ExpandButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Développer/Rétracter le journal des événements"
				},
				{
					id = 2,
					type = "description",
					text = "Développe ou rétracte le journal des événements de combat."
				}
			];

		case "tactical-screen.topbar.round-information-module.BrothersCounter":
			return [
				{
					id = 1,
					type = "title",
					text = "Alliés"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de frères d\'armes controllés par vous ou vos alliés (controllés par l\'IA) sur le champ de bataille."
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
					text = "Le nombre de tours joués depuis ue la bataille a commencé."
				}
			];

		case "tactical-screen.topbar.options-bar-module.CenterButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Centrer la caméra (Maj)"
				},
				{
					id = 2,
					type = "description",
					 text = "Centre la caméra sur le personnage actuellement en action."
				}
			];

		case "tactical-screen.topbar.options-bar-module.ToggleHighlightBlockedTilesButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Affiche/Cache la surbrillance sur les tuiles bloqués (B)"
				},
				{
					id = 2,
					type = "description",
					text = "Bacule entre afficher et cacher l\'affichage en rouge pour indiquer les tuiles bloqués par l\'environnement (comme les arbres) où les personnages ne peuvent s\'y déplacer."
				}
			];

		case "tactical-screen.topbar.options-bar-module.SwitchMapLevelUpButton":
			return [
				{
					id = 1,
					type = "title",
					 text = "Élever le niveau de la caméra (+)"
				},
				{
					id = 2,
					type = "description",
					text = "Élever le niveau de la caméra pour voir les parties plus élevées de la carte."
				}
			];

		case "tactical-screen.topbar.options-bar-module.SwitchMapLevelDownButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Descendre d'un niveau de caméra (-)"
				},
				{
					id = 2,
					type = "description",
					 text = "Descendre d'un niveau de caméra et masquer les parties élevées de la carte."
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
					text = "Basculer entre afficher et cacher les barres d\'armure et de points de vie, ainsi que les icônes d\'effet de statut, au dessus de chaque personnage visible."
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
					text = "Fuyez le combat et courrez pour vos vies. Il est mieux de se battre un autre jour ue de mourrir ici inutilement."
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
					text = "Met en pause le tour du personnage actif et le place en fin de queue. Attendre ce tour, vous fera aussi agir plus tard au tour d\'après."
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
					text = "Fini le tour, ce qui fera passer le tour à tous vos personnages jusqu\'à ce que le prochain tour commence."
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
					text = "Ouvre la page de personnage et d\'inventaire pour le Frère d\'arme actif."
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
					text = "Quitter le combat tactiue et retourner à la map du monde."
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
					text = "Ce personnage vient de monter de niveau! Trouvez-le dans votre compagnie, accessible depuis la map monde pour monter ses attributs et sélectionner un Talent."
				}
			];
			return result;

		case "tactical-combat-result-screen.statistics-panel.DaysWounded":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Blessures légères"
				},
				{
					id = 2,
					type = "description",
					text = "Petit bleu, petite perte de sang et autres blessures superficielles qui ont provoqués une perte de points de vie à ce personnage sans impacter leurs compétences."
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
						text = "Sera soigné d\'ici demain"
					});
				}
				else
				{
					result.push({
						id = 1,
						type = "text",
						icon = "ui/icons/days_wounded.png",
						text = "Sera soigné d\'ici [color=" + this.Const.UI.Color.NegativeValue + "]" + entity.getDaysWounded() + "[/color] jours"
					});
				}
			}

			return result;

		case "tactical-combat-result-screen.statistics-panel.KillsValue":
			return [
				{
					id = 1,
					type = "title",
					text = "Tués"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre d\'ennemis que ce personnage a tué durant cette bataille."
				}
			];

		case "tactical-combat-result-screen.statistics-panel.XPReceivedValue":
			return [
				{
					id = 1,
					type = "title",
					text = "Experience Gagné"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de point d\'expérience gagné en combattant et tuant des ennemis. Gagner assez de points d\'expérience permettra à ce personnage de montre de niveau, ce qui augmentera ses attributs et lui permettra de choisir un Talent."
				}
			];

		case "tactical-combat-result-screen.statistics-panel.DamageDealtValue":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Dégats Causés"
				},
				{
					id = 2,
					type = "description",
					text = "Les dégats causés par ce personnage pendant le combat (Points de vie et armure)."
				}
			];

			if (entity != null)
			{
				local combatStats = entity.getCombatStats();
				result.push({
					id = 1,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "A causé [color=" + this.Const.UI.Color.PositiveValue + "]" + combatStats.DamageDealtHitpoints + "[/color] dommages aux points de vie"
				});
				result.push({
					id = 2,
					type = "text",
					icon = "ui/icons/shield_damage.png",
					text = "A causé [color=" + this.Const.UI.Color.PositiveValue + "]" + combatStats.DamageDealtArmor + "[/color] dommages à l\'armure"
				});
			}

			return result;

		case "tactical-combat-result-screen.statistics-panel.DamageReceivedValue":
			local result = [
				{
					id = 1,
					type = "title",
					text = "Dégats Reçus"
				},
				{
					id = 2,
					type = "description",
					text = "Les dégats reçus par ce personnage, partagés en dommages à l\'armure et aux points de vie. Ces valeurs sont après application des réductions de dommages."
				}
			];

			if (entity != null)
			{
				local combatStats = entity.getCombatStats();
				result.push({
					id = 1,
					type = "text",
					icon = "ui/icons/regular_damage.png",
					text = "A reçu [color=" + this.Const.UI.Color.NegativeValue + "]" + combatStats.DamageReceivedHitpoints + "[/color] de dommages aux points de vie"
				});
				result.push({
					id = 2,
					type = "text",
					icon = "ui/icons/shield_damage.png",
					text = "A reçu [color=" + this.Const.UI.Color.NegativeValue + "]" + combatStats.DamageReceivedArmor + "[/color] de dommages à l\'armure"
				});
			}

			return result;

		case "tactical-combat-result-screen.loot-panel.LootAllItemsButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Récolte tous les objets"
				},
				{
					id = 2,
					type = "description",
					text = "Récolte tous les objets jusqu\'à ce que l\'inventaire soit rempli."
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
					text = "Les personnages gagnent des points d\'expérience quand vous ou vos alliés tuent des ennemies en bataille. Si un combattant accumule assez d\'expérience, il montera de niveau et aura la possibilité de monter ses attributs et de sélectionner un Talent qui offrira un bonus unique.\n\nAu dessus du level 11, les personnages sont des vétérans et ne gagneront plus de points de Talent, mais ils continueront de s\'ameliorer."
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
					text = "Le niveau d\'un personnage mesure son niveau d\'expérience au combat. Les personnages montent en niveau au fur et à mesure qu\'ils gagnent de l\'expérience et gagne la possibilité de gagner des Talents qui les rendent meilleurs dans leur travail de mercenaires.\n\nAu dessus du level 11, les personnages sont des vétérans et ne gagneront plus de points de Talent, mais ils continueront de s\'ameliorer."
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
					text = "Ce personnage est monté de niveau. Monter ses attributs et sélectionner un Talent!"
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
					text = "Renvoyer ce personnage de votre compagnie pour économiser sur le salaire journalier et faire de la place pour quelqu\'un d\'autre. Les personnages endettés seront libérés de l\'esclavage et quitteront votre compagnie."
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
					text = "Afficher l\'inventaire global de votre compagnie de mercenaire, ou voir ce qu\'il y a au sol pour le personnage sélectionner pendant un combat."
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
					text = "Afficher les Talents du personnage sélectionné.\n\nLe nombre entre crochets, s\'il y en a, est le nombre disponible de points de Talents."
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
					text = "Montre seulements les ressources, nourritures, trésors et autres."
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
					text = "Montre seulements les objets utilisables en mode inventaire, comme les peintures ou les améliorations d\'armures."
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
					text = "Commencer la bataille en utilisant l\'équipement sélectionné."
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
					text = "Dépenser ces points pour augmenter 3 des 8 attributs par niveau par un nombre aléatoire. Un attribut peut seulement être augmenté une fois seulement par niveau.\n\nLes étoiles signifient qu\'un personnage est talentueux dans un attribut spécifique, ce qui permet d\'avoir régulièrement de meilleures jets de stats."
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
					text = "Payer une compensation, un pourboir ou une pension pour le temps travaillé dans la compagnie permettra à la personne renvoyée de partir avec honneur et lui permettra de commencer une nouvelle vie, cela empêchera les autres membres de la compagnie de réagir avec colère au renvoie du personnage.\n\nPour les personnages endettés une indemnité leur est payé pour leur temps passés au sein de la compagnie. Les autres personnages endettés apprécieront si vous payez l\'indemnité, mais ne seront pas non plus en colère si vous ne le faites pas."
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
					text = "Le jeu s\'écoulera à une vitesse normale."
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
					text = "Le jeu s\'écoulera plus rapidement que la normale."
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
					text = "Montre les détails de votre contrat actif."
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
					text = "Centrer la caméra (Return, Shift)"
				},
				{
					id = 2,
					type = "description",
					text = "Bouger la caméra pour la centrer et la faire zoomer sur votre compagnie de mercenaires."
				}
			];

		case "world-screen.topbar.options-module.CameraLockButton":
			return [
				{
					id = 1,
					type = "title",
					text = "Activer le blocage de la caméra (X)"
				},
				{
					id = 2,
					type = "description",
					text = "Active ou désactive la caméra pour toujours être centré sur votre compagnie de mercenaires."
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
					text = "Affiche ou cache les empreintes laissés par les autres groupes qui sillonnent le monde pour que vous puissez les suivre ou les éviter plus facilement."
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
					text = "Faire ou défaire le camp. Pendant que vous camper, le temps passera plus vite et vos hommes se soigneront et répareront leur équipement plus rapidement. Cependant, vous êtes aussi plus succeptible d\'être victime d\'une attaque surprise."
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
					text = "Dans le carnet de deuil ayez accès à la liste de tous vos compagnons qui sont tombés au combat depuis que vous êtes aux commandes."
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
					text = "Le nombre de jours où le personnage a été dans la compagnie avant son décès."
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
					text = "Le nombres de batailles dont le personnage a participé avant son décès."
				}
			];

		case "world-screen.obituary.ColumnKills":
			return [
				{
					id = 1,
					type = "title",
					text = "Tués"
				},
				{
					id = 2,
					type = "description",
					text = "Le nombre de tués que le personnage a accumulé avant son décès."
				}
			];

		case "world-screen.obituary.ColumnKilledBy":
			return [
				{
					id = 1,
					type = "title",
					text = "Décès"
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
					text = "Quitter et retourner à la carte du monde."
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
					text = "Quelqu\'un cherche à employer des mercenaires."
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
					text = "Les termes du contrat ont été négociés. Tout ce qu\'il vous reste à faire c\'est de le signer."
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.ContractDisabled":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Vous avez déjà un contrat!"
				},
				{
					id = 2,
					type = "description",
					text = "Vous pouvez avoir seulement un contrat actif à un moment donné. Les offres de contrats resteront pendant que vous effectuez le contrat actuel, à moins que le problème ne disparaisse d\'ici là."
				}
			];
			return ret;

		case "world-town-screen.main-dialog-module.ContractLocked":
			local ret = [
				{
					id = 1,
					type = "title",
					text = "Contrats Bloqués"
				},
				{
					id = 2,
					type = "description",
					text = "Seulement les contrats donnés par les nobles possédant cette fortification sont disponibles ici, mais vous n\'êtes pas digne de leur attention. Augmentez votre renom et accomplissez l\'ambition des maisons des nobles pour qu\'il remarque la compagnie et vous confient des contrats!"
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
					text = "Engager de nouveaux hommes dans votre compagnie de mercenaires. La qualité et la quantité de volontaire dépend de la taille et du type de colonie. Tous les quelques jours, de nouvelles personnes arriveront, et d\'autres partiront."
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
					text = "Une grande taverne templie de clients des quatres coins du monde, elle offre boissons, nourriture possède une atmophère vivante dans laquelle il est possible de partager des rumeurs et des informations."
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
					text = "Un refuge contre le monde brutal de dehors. Vous pourrez y chercher de l\'aide pour soigner vos bléssés et y prier pour le salut éternel de vos âmes."
				}
			];

		case "world-town-screen.main-dialog-module.VeteransHall":
			return [
				{
					id = 1,
					type = "title",
					text = "Salle d\'entraînement"
				},
				{
					id = 2,
					type = "description",
					text = "Un lieu de rassemblement pour ceux qui pratiquent une profession de combat. Ayez vos hommes s\'entraîner ici pour apprendre de guerriers aguerris, pour que vous puissiez les forger plus rapidement en des mercenaires endurcies."
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
					text = "Pour le bon prix un taxidermiste pourra vous créer des objets utiles à partir de toutes les sortes de trophées que vous lui ramènerez."
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
					text = "Un chenil où des chiens fort et rapides sont élevés pour la guerre."
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
					text = "Personnaliser l\'apparence de vos hommes chez le barbier. Ayez leurs cheveux et barbes coupés ou achetés des potions douteuse pour leur faire perdre du poids."
				}
			];

		case "world-town-screen.main-dialog-module.Fletcher":
			return [
				{
					id = 1,
					type = "title",
					text = "Fabricant de flèches"
				},
				{
					id = 2,
					type = "description",
					text = "Le fabricant de flèche se spécialise dans toutes les sortes d\'armes à distance."
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
					text = "Arène"
				},
				{
					id = 2,
					type = "description",
					text = "L\'arène permet de gagner de l\'or et de la gloire en se battant dans des combats jusqu\'à la mort, et tout devant les cris du public qui s\'exclame devant les morts les plus atroces et sanglantes."
				}
			];

			if (this.World.State.getCurrentTown() != null && this.World.State.getCurrentTown().getBuilding("building.arena").isClosed())
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Il n\'y a plus de matches de planifiés pour aujourd\'hui. Revenez demain!"
				});
			}

			if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getType() != "contract.arena" && this.World.Contracts.getActiveContract().getType() != "contract.arena_tournament")
			{
				ret.push({
					id = 3,
					type = "hint",
					icon = "ui/tooltips/warning.png",
					text = "Vous ne pouvez combattre dans l\'arène quand vous avez déjà un contrat actif"
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
					text = "Vous avez besoin d\'au moins 3 emplacements d\'inventaire vide pour combattre dans l\'arène"
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
					text = "Le port est utilisé autant par les bateaux de commerce lointain que par les bateaux de pêches locaux. Vous aurez probablement la possibilité de réserver un voyage vers d\'autres parties du continent ici."
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
					text = "Marché"
				},
				{
					id = 2,
					type = "description",
					text = "Le marché est un lieu animé offrant toute sorte de biens produit dans la région. De nouveaux biens sont produits tous les quelques jours et quand des caravanes atteignent cette colonie."
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
					text = "Le forgeron d\'armes met en étalage toutes sortes d\'armes de mélés créé à la main. L\'équipement endommagé peut y être réparé contre une petite compensation."
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
					text = "Le forgeron d\'armure est le bon endroit pour chercher des biens bien fait et une protection durable. L\'équipement endommagé peut y être réparé contre une petite compensation."
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
					text = "Quitter cet écran et retourner à celui précédent."
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
					text = "Engager la recrue sélectionner pour qu\'elle rejoigne votre compagnie."
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
					text = "Donner une periode d\'essai à la recrue pour révéler ses traits cachés, si elle en a."
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
					text = "Ce personnage pourrait avoir des traits inconnus. Vous pouvez payer pour les révélés."
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
					text = "Payer le prix indiqué, et fournisser les composants nécessaires pour recevoir l\'objet fabriqué en retour."
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
					text = "Quitter cet écran et retourner à celui précédent."
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
					text = "Réserver le voyage pour que votre compagnie puisse faire un voyage rapide vers la destination selectionnée."
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
					text = "Quitter cet écran et retourner à celui précédent."
				}
			];

		case "world-town-screen.training-dialog-module.Train1":
			return [
				{
					id = 1,
					type = "title",
					text = "Combat d\'entraînement"
				},
				{
					id = 2,
					type = "description",
					text = "Ayez un de vos homme participer à une joute amicale contre des combattants expérimentés utilisant des styles de combat variés. Les bleus reçus et les leçons apprîses se traduisent en un gain de [color=" + this.Const.UI.Color.PositiveValue + "]+50%[/color] d\'expérience pour la prochaine bataille."
				}
			];

		case "world-town-screen.training-dialog-module.Train2":
			return [
				{
					id = 1,
					type = "title",
					text = "Les leçons d\'un vétéran"
				},
				{
					id = 2,
					type = "description",
					text = "Ayez un de vos homme participer à des leçons et un transferts de connaissances par des vétérans du métier. La connaissance acquise se traduit par un gain de [color=" + this.Const.UI.Color.PositiveValue + "]+35%[/color] d\'expérience pour les trois prochaines batailles."
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
					text = "Ayez un de vos homme participer à un entraiment rigoureux de régiment pour le façonner en un combatant expérimenté. Le sang et les larmes versés lui seront bénéfiques et se traduisent sur le long terme par un gain de [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] d\'expérience pour les cinq prochaines batailles."
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
					text = "Quitter le jeu et retourner au menu principal. Votre progrès ne sera pas sauvegardé."
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
					text = "Vos relations avec une faction détermine si elle vous combattront ou agiront pacifiquement envers vous, leur volonté de vous engager pour des contrats, le prix qu\'ils seront prêt à vous payer ainsi que le nombre de recrues qui vous seront accessible dans leur colonies.\n\nLes relations augmentent en menant un bien des contract pour les factions, et diminuent quand vous échouez, quand vous les trahissez ou quand vous les attaquez. Au fur et à mesure que le temps d\'écoule, les relations se dirige vers la neutralité."
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
					text = "Une compagnie de mercenaire transporte énormement d\'équipement et de ressources. En utilisant des chariots et des carriages, vous pouvez agrandir l\'espace d\'inventaire disponible et vous pourrez donc transporter encore plus."
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
					 text = "Le DLC gratuit Lindwurm ajoute une nouvelle bête difficile, un nouveau bannière de joueur, ainsi qu'une nouvelle armure renommée, un casque et un bouclier."
				}
			];

			if (this.Const.DLC.Lindwurm == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]Ce DLC est installé.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Ce DLC est manquant. Il est disponible gratuitement sur Steam et GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Ouvrir la page du magasin dans le navigateur"
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
					text = "Le DLC Beasts & Exploration ajoute une variété de nouvelles créatures errant dans les contrées sauvages, un nouveau système d'artisanat pour créer des objets à partir de trophées, des lieux légendaires avec des récompenses uniques à découvrir, de nombreux nouveaux contrats et événements, un nouveau système d'accessoires d'armure, de nouvelles armes, armures et objets utilisables, et plus encore."
				}
			];

			if (this.Const.DLC.Unhold == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]Ce DLC est installé.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Ce DLC est manquant. Il est disponible à l'achat sur Steam et GOG![/color]";
			}

			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Ouvrir la page du magasin dans le navigateur"
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
					text = "Le DLC Blazing Deserts ajoute une nouvelle région désertique au sud inspirée par les cultures arabes et perses médiévales, une nouvelle crise en fin de partie impliquant une guerre sainte, une suite de suiveurs non combattants avec lesquels personnaliser votre compagnie, des engins alchimiques et des armes à feu primitives, de nouveaux adversaires humains et bestiaux, de nouveaux contrats et événements, et plus encore."
				}
			];

			if (this.Const.DLC.Desert == true)
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.PositiveValue + "]Ce DLC est installé.[/color]";
			}
			else
			{
				ret[1].text += "\n\n[color=" + this.Const.UI.Color.NegativeValue + "]Ce DLC est manquant. Il est disponible à l'achat sur Steam et GOG![/color]";
			}
			
			ret.push({
				id = 1,
				type = "hint",
				icon = "ui/icons/mouse_left_button.png",
				text = "Ouvrir la page du magasin dans le navigateur"
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
				text = "Ouvrir la page du magasin dans le navigateur"
			});
			return ret;
		}

		return null;
	}

};

