this.tactical_state <- this.inherit("scripts/states/state", {
	m = {
		TacticalScreen = null,
		CharacterScreen = null,
		TacticalDialogScreen = null,
		TacticalMenuScreen = null,
		TacticalCombatResultScreen = null,
		MenuStack = null,
		Factions = null,
		CameraDirector = null,
		IsAllowingDeveloperMode = true,
		IsDeveloperModeEnabled = null,
		IsFogOfWarVisible = null,
		IsAIPaused = null,
		IsGamePaused = null,
		IsFleeing = false,
		IsShowingFleeScreen = false,
		IsEnemyRetreatDialogShown = false,
		IsBattleEnded = false,
		IsExitingToMenu = false,
		IsAutoRetreat = false,
		CurrentActionState = null,
		SelectedSkillID = null,
		IsInputLocked = false,
		LastFatigueSoundTime = 0.0,
		LastTileSelected = null,
		LastTileHovered = null,
		LastTileHoveredHadEntity = null,
		ActiveEntityNeedsUpdate = null,
		ActiveEntityMouseHover = null,
		MouseDownPosition = null,
		IsInCameraMovementMode = false,
		WasInCameraMovementMode = false,
		CursorBeforeCameraMovement = null,
		UseDragStyleScrolling = null,
		ScrollDirectionX = null,
		ScrollDirectionY = null,
		OnCameraMovementStartCallback = null,
		OnCameraMovementEndCallback = null,
		Scenario = null,
		StrategicProperties = null,
		CombatResultRoster = null,
		CombatResultLoot = null,
		MaxHostiles = 0,
		IsGameFinishable = null
	},
	function isFleeing()
	{
		return this.m.IsFleeing;
	}

	function isScenarioMode()
	{
		return this.m.Scenario != null;
	}

	function isBattleEnded()
	{
		return this.m.IsBattleEnded;
	}

	function isAutoRetreat()
	{
		return this.m.IsAutoRetreat;
	}

	function isPaused()
	{
		return this.m.IsGamePaused;
	}

	function setInputLocked( _v )
	{
		this.m.IsInputLocked = _v;
	}

	function getLastTileHovered()
	{
		return this.m.LastTileHovered;
	}

	function getCurrentActionState()
	{
		return this.m.CurrentActionState;
	}

	function getSelectedSkillID()
	{
		return this.m.SelectedSkillID;
	}

	function getStrategicProperties()
	{
		return this.m.StrategicProperties;
	}

	function isInCameraMovementMode()
	{
		return this.m.IsInCameraMovementMode;
	}

	function wasInCameraMovementMode()
	{
		return this.m.WasInCameraMovementMode;
	}

	function setScenario( _s )
	{
		this.m.Scenario = _s;
	}

	function setStrategicProperties( _p )
	{
		this.m.StrategicProperties = _p;
	}

	function isInputLocked()
	{
		return this.m.IsInputLocked || !this.Tactical.CameraDirector.isInputAllowed();
	}

	function disableCameraMode()
	{
		this.m.IsInCameraMovementMode = false;
		this.m.WasInCameraMovementMode = false;
		this.m.MouseDownPosition = null;
	}

	function setPause( _f )
	{
		this.m.IsGamePaused = _f;

		if (_f)
		{
			this.Time.setVirtualSpeed(0.0);
			this.m.IsAIPaused = true;
		}
		else
		{
			this.Time.setVirtualSpeed(1.0);
			this.m.IsAIPaused = false;
		}
	}

	function onInit()
	{
		this.m.IsDeveloperModeEnabled = this.isDevmode() || !this.isReleaseBuild();
		this.m.IsAllowingDeveloperMode = false;
		this.m.IsGameFinishable = true;
		this.m.IsFogOfWarVisible = true;
		this.m.ActiveEntityNeedsUpdate = false;
		this.m.UseDragStyleScrolling = true;
		this.setPause(false);
		this.Tactical.State <- this.WeakTableRef(this);
		this.Tactical.setActive(true);
		this.m.Factions = this.new("scripts/entity/tactical/tactical_entity_manager");
		this.Tactical.Entities <- this.WeakTableRef(this.m.Factions);
		this.Tactical.Entities.setOnCombatFinishedListener(this.onBattleEnded.bindenv(this));
		this.m.CameraDirector = this.new("scripts/camera/tactical_camera_director");
		this.Tactical.CameraDirector <- this.WeakTableRef(this.m.CameraDirector);
		this.m.OnCameraMovementStartCallback = this.onCameraMovementStart.bindenv(this);
		this.m.OnCameraMovementEndCallback = this.onCameraMovementEnd.bindenv(this);
		this.Tactical.getCamera().registerCallbacks(this.m.OnCameraMovementStartCallback, this.m.OnCameraMovementEndCallback);
		this.m.CombatResultLoot = this.new("scripts/items/stash_container");
		this.m.CombatResultLoot.setResizable(true);
		this.Tactical.CombatResultLoot <- this.WeakTableRef(this.m.CombatResultLoot);

		if (this.Const.AI.ParallelizationMode)
		{
			this.Root.setBackgroundTaskCallback(this.onProcessAI.bindenv(this));
		}

		this.onInitUI();
	}

	function onInitUI()
	{
		this.m.MenuStack <- this.new("scripts/ui/global/menu_stack");
		this.m.MenuStack.setEnviroment(this);
		this.m.TacticalScreen <- this.new("scripts/ui/screens/tactical/tactical_screen");
		this.m.TacticalScreen.setOnConnectedListener(this.tacticalscreen_onConnected.bindenv(this));
		local tsb = this.m.TacticalScreen.getTurnSequenceBarModule();
		tsb.setOnNextTurnListener(this.turnsequencebar_onNextTurn.bindenv(this));
		tsb.setOnNextRoundListener(this.turnsequencebar_onNextRound.bindenv(this));
		tsb.setOnEntitySkillClickedListener(this.turnsequencebar_onEntitySkillClicked.bindenv(this));
		tsb.setOnEntitySkillCancelClickedListener(this.turnsequencebar_onEntitySkillCancelClicked.bindenv(this));
		tsb.setOnEntityEnteredFirstSlotListener(this.turnsequencebar_onEntityEnteredFirstSlot.bindenv(this));
		tsb.setOnEntityEnteredFirstSlotFullyListener(this.turnsequencebar_onEntityEnteredFirstSlotFully.bindenv(this));
		tsb.setOnEntityMouseEnterListener(this.turnsequencebar_onEntityMouseEnter.bindenv(this));
		tsb.setOnEntityMouseLeaveListener(this.turnsequencebar_onEntityMouseLeave.bindenv(this));
		tsb.setOnOpenInventoryButtonPressed(this.showCharacterScreen.bindenv(this));
		tsb.setCheckEnemyRetreatListener(this.turnsequencebar_onCheckEnemyRetreat.bindenv(this));
		local ri = this.m.TacticalScreen.getTopbarRoundInformationModule();
		ri.setOnQueryRoundInformationListener(this.topbar_round_information_onQueryRoundInformation.bindenv(this));
		local ob = this.m.TacticalScreen.getTopbarOptionsModule();
		ob.setOnToggleHighlightBlockedTilesListener(this.topbar_options_onToggleHighlightBlockedTilesButtonClicked.bindenv(this));
		ob.setOnSwitchMapLevelUpListener(this.topbar_options_onSwitchMapLevelUpButtonClicked.bindenv(this));
		ob.setOnSwitchMapLevelDownListener(this.topbar_options_onSwitchMapLevelDownButtonClicked.bindenv(this));
		ob.setOnToggleStatsOverlaysListener(this.topbar_options_onToggleStatsOverlaysButtonClicked.bindenv(this));
		ob.setOnToggleTreesListener(this.topbar_options_onToggleTreesButtonClicked.bindenv(this));
		ob.setOnFleePressedListener(this.topbar_options_onFleeButtonClicked.bindenv(this));
		ob.setOnQuitPressedListener(this.topbar_options_onQuitButtonClicked.bindenv(this));
		ob.setOnCenterPressedListener(this.topbar_options_onCenterButtonClicked.bindenv(this));
		this.m.CharacterScreen <- this.new("scripts/ui/screens/character/character_screen");
		this.m.CharacterScreen.setOnCloseButtonClickedListener(this.hideCharacterScreen.bindenv(this));
		this.m.CharacterScreen.setOnStartBattleButtonClickedListener(this.hideCharacterScreen.bindenv(this));
		this.m.TacticalDialogScreen <- this.new("scripts/ui/screens/tactical/tactical_dialog_screen");
		this.m.TacticalMenuScreen <- this.new("scripts/ui/screens/menu/tactical_menu_screen");
		local mainMenuModule = this.m.TacticalMenuScreen.getMainMenuModule();
		mainMenuModule.setOnResumePressedListener(this.main_menu_module_onResumePressed.bindenv(this));
		mainMenuModule.setOnOptionsPressedListener(this.main_menu_module_onOptionsPressed.bindenv(this));
		mainMenuModule.setOnFleePressedListener(this.main_menu_module_onFleePressed.bindenv(this));
		mainMenuModule.setOnQuitPressedListener(this.main_menu_module_onQuitPressed.bindenv(this));
		local optionsMenuModule = this.m.TacticalMenuScreen.getOptionsMenuModule();
		optionsMenuModule.setOnOkButtonPressedListener(this.options_menu_module_onOkPressed.bindenv(this));
		optionsMenuModule.setOnCancelButtonPressedListener(this.options_menu_module_onCancelPressed.bindenv(this));
		this.m.TacticalCombatResultScreen <- this.new("scripts/ui/screens/tactical/tactical_combat_result_screen");
		this.m.TacticalCombatResultScreen.setOnLeavePressedListener(this.tactical_combat_result_screen_onLeavePressed.bindenv(this));
		this.m.TacticalCombatResultScreen.setOnQueryCombatInformationListener(this.tactical_combat_result_screen_onQueryCombatInformation.bindenv(this));
		this.m.TacticalScreen.connect();
		this.initLoadingScreenHandler();
	}

	function main_menu_module_onQuitPressed()
	{
		this.m.IsShowingFleeScreen = true;
		this.m.MenuStack.pop();
		this.setPause(true);
		this.Tooltip.hide();
		this.m.TacticalScreen.hide();

		if (!this.World.Assets.isIronman())
		{
			this.showDialogPopup("Quitter au menu principal", "Êtes-vous sûr de vouloir quitter cette bataille et retourner au menu principal ?\n\nTous les progrès réalisés dans la bataille seront perdus, mais une sauvegarde automatique a été effectuée juste avant le début de la bataille.", this.onQuitToMainMenu.bindenv(this), this.onCancelQuitToMainMenu.bindenv(this));
		}
		else
		{
			this.showDialogPopup("Quitter et Prendre sa retraite", "Êtes-vous sûr de vouloir abandonner cette bataille et ainsi renoncer à votre course Ironman et vous retirer de votre compagnie ?\n\nVotre sauvegarde sera supprimée et vous ne pourrez plus continuer.", this.onQuitToMainMenu.bindenv(this), this.onCancelQuitToMainMenu.bindenv(this));
		}

		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
	}

	function onCancelQuitToMainMenu()
	{
		this.setPause(false);
	}

	function onQuitToMainMenu()
	{
		this.m.IsBattleEnded = true;
		this.m.IsAIPaused = true;
		this.m.IsExitingToMenu = true;
		this.LoadingScreen.show();
	}

	function onDestroyUI()
	{
		this.m.TacticalMenuScreen.destroy();
		this.m.TacticalDialogScreen.destroy();
		this.m.CharacterScreen.destroy();
		this.m.TacticalScreen.destroy();
		this.m.TacticalCombatResultScreen.destroy();
		this.m.MenuStack.destroy();
		this.m.MenuStack = null;
		this.m.TacticalMenuScreen = null;
		this.m.TacticalDialogScreen = null;
		this.m.TacticalCombatResultScreen = null;
		this.m.CharacterScreen = null;
		this.m.TacticalScreen = null;
	}

	function onFinish()
	{
		this.logDebug("TacticalState::onFinish");
		this.Time.clearEvents();
		this.Sound.stopAmbience();
		this.Tactical.getCamera().unregisterCallbacks(this.m.OnCameraMovementStartCallback, this.m.OnCameraMovementEndCallback);
		this.onDestroyUI();
		this.Tactical.clearScene();
		this.Tactical.setVisible(false);
		this.m.Factions = null;
		this.Tactical.Entities = null;
		this.m.CameraDirector = null;
		this.Tactical.CameraDirector = null;
		this.Tactical.State = null;
		this.Tactical.getCasualtyRoster().clear();
		this.Tactical.getSurvivorRoster().clear();
		this.Tactical.getRetreatRoster().clear();
		this.m.CombatResultRoster = null;

		if ("CombatResultRoster" in this.Tactical)
		{
			this.Tactical.CombatResultRoster = null;
		}

		this.m.CombatResultLoot.clear();
		this.m.CombatResultLoot = null;

		if ("CombatResultLoot" in this.Tactical)
		{
			this.Tactical.CombatResultLoot = null;
		}

		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);

		if (this.Const.AI.ParallelizationMode)
		{
			this.Root.setBackgroundTaskCallback(null);
		}

		this.Settings.getTempGameplaySettings().FasterPlayerMovement = false;
		this.Settings.getTempGameplaySettings().FasterAIMovement = false;
	}

	function onShow()
	{
		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);

		if (this.Stash.isLocked() == true)
		{
			if (this.m.Scenario != null)
			{
				this.Music.setTrackList(this.m.Scenario.getMusic(), this.Const.Sound.CrossFadeTime);
			}
			else
			{
				local faction = this.m.Factions.getHostileFactionWithMostInstances();
				this.World.Statistics.getFlags().set("LastCombatFaction", faction);

				if (this.m.StrategicProperties != null)
				{
					if (this.m.StrategicProperties.IsAttackingLocation && this.World.State.getLastLocation() != null)
					{
						this.World.State.getLastLocation().setVisited(true);
					}

					this.World.Statistics.getFlags().set("LastCombatWasOngoingBattle", this.m.StrategicProperties.InCombatAlready);
					this.World.Statistics.getFlags().set("LastCombatWasArena", this.m.StrategicProperties.IsArenaMode);
					this.Music.setTrackList(this.m.StrategicProperties.Music, this.Const.Music.CrossFadeTime);
				}
				else
				{
					this.Music.setTrackList(this.Const.Music.BattleTracks[faction], this.Const.Music.CrossFadeTime);
				}
			}

			this.m.TacticalScreen.show();
		}

		this.Tactical.setVisible(true);
	}

	function onHide()
	{
		this.hideCharacterScreen(true);
		this.m.TacticalScreen.hide();
		this.m.TacticalMenuScreen.hide();
		this.Tactical.setVisible(false);
	}

	function onSiblingSentMessage( _stateName, _message )
	{
		if ((_stateName == "MainMenuState" || _stateName == "WorldState") && _message == "FullyLoaded")
		{
			this.finish();
		}
	}

	function onUpdate()
	{
		this.Tactical.TurnSequenceBar.update();

		if (this.Tactical.Entities.isCombatFinished() && !this.m.IsBattleEnded)
		{
			if (this.m.IsAutoRetreat && this.Tactical.getRetreatRoster().getSize() != 0)
			{
				this.Time.clearEvents();
				this.setPause(true);
				this.flee();
			}
			else
			{
				this.onBattleEnded();
			}
		}

		this.updateCurrentEntity();
		this.Tactical.CameraDirector.update();
		this.Tactical.getCamera().update();
		this.Tactical.update();
		this.updateScene();
		this.updateOrientationOverlays();
		this.updateCameraScrolling();
		this.m.Factions.update();
	}

	function onRender()
	{
		if (this.m.CharacterScreen.isVisible() && this.m.CharacterScreen.isInBattlePreparationMode())
		{
			return;
		}

		this.Tactical.render();
		this.renderScene();
		this.Tactical.getNavigator().render();

		if (!this.m.CharacterScreen.isVisible() && !this.m.TacticalCombatResultScreen.isVisible())
		{
			this.renderOrientationOverlays();
		}
	}

	function onKeyInput( _key )
	{
		return this.helper_handleContextualKeyInput(_key);
		return false;
	}

	function onMouseInput( _mouse )
	{
		local mouseMoved = _mouse.getID() == 6;

		if (mouseMoved)
		{
			this.Cursor.setPosition(_mouse.getX(), _mouse.getY());
		}

		if (this.isInLoadingScreen() || this.m.IsBattleEnded)
		{
			return true;
		}

		if (mouseMoved)
		{
			this.updateCursorAndTooltip();
		}

		this.updateCamera(_mouse);

		if (this.isInputLocked())
		{
			return true;
		}

		if (_mouse.getID() == 7)
		{
			if (_mouse.getState() == 3)
			{
				this.Tactical.getCamera().zoomBy(-this.Time.getDelta() * this.Math.max(60, this.Time.getFPS()) * 0.3);
				return true;
			}
			else if (_mouse.getState() == 4)
			{
				this.Tactical.getCamera().zoomBy(this.Time.getDelta() * this.Math.max(60, this.Time.getFPS()) * 0.3);
				return true;
			}
		}

		if (_mouse.getState() == 1)
		{
			return this.setActionStateByMouseEvent(_mouse);
		}

		return false;
	}

	function onContextLost()
	{
		this.Tactical.getCamera().updateEntityOverlays();
	}

	function gatherLoot()
	{
		local playerKills = 0;

		foreach( bro in this.m.CombatResultRoster )
		{
			playerKills = playerKills + bro.getCombatStats().Kills;
		}

		if (!this.isScenarioMode())
		{
			this.World.Statistics.getFlags().set("LastCombatKills", playerKills);
		}

		local isArena = !this.isScenarioMode() && this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode;

		if (!isArena && !this.isScenarioMode() && this.m.StrategicProperties != null && this.m.StrategicProperties.IsLootingProhibited)
		{
			return;
		}

		local loot = [];
		local size = this.Tactical.getMapSize();

		for( local x = 0; x < size.X; x = ++x )
		{
			for( local y = 0; y < size.Y; y = ++y )
			{
				local tile = this.Tactical.getTileSquare(x, y);

				if (tile.IsContainingItems)
				{
					foreach( item in tile.Items )
					{
						if (isArena && item.getLastEquippedByFaction() != 1)
						{
							continue;
						}

						item.onCombatFinished();
						loot.push(item);
					}
				}

				if (tile.Properties.has("Corpse") && tile.Properties.get("Corpse").Items != null)
				{
					local items = tile.Properties.get("Corpse").Items.getAllItems();

					foreach( item in items )
					{
						if (isArena && item.getLastEquippedByFaction() != 1)
						{
							continue;
						}

						item.onCombatFinished();

						if (!item.isChangeableInBattle() && item.isDroppedAsLoot())
						{
							if (item.getCondition() > 1 && item.getConditionMax() > 1 && item.getCondition() > item.getConditionMax() * 0.66 && this.Math.rand(1, 100) <= 50)
							{
								local c = this.Math.minf(item.getCondition(), this.Math.rand(this.Math.maxf(10, item.getConditionMax() * 0.35), item.getConditionMax()));
								item.setCondition(c);
							}

							item.removeFromContainer();
							loot.push(item);
						}
					}
				}
			}
		}

		if (!isArena && this.m.StrategicProperties != null)
		{
			local player = this.World.State.getPlayer();

			foreach( party in this.m.StrategicProperties.Parties )
			{
				if (party.getTroops().len() == 0 && party.isAlive() && !party.isAlliedWithPlayer() && party.isDroppingLoot() && (playerKills > 0 || this.m.IsDeveloperModeEnabled))
				{
					party.onDropLootForPlayer(loot);
				}
			}

			foreach( item in this.m.StrategicProperties.Loot )
			{
				loot.push(this.new(item));
			}
		}

		if (!isArena && !this.isScenarioMode())
		{
			if (this.Tactical.Entities.getAmmoSpent() > 0 && this.World.Assets.m.IsRecoveringAmmo)
			{
				local amount = this.Math.max(1, this.Tactical.Entities.getAmmoSpent() * 0.2);
				amount = this.Math.rand(amount / 2, amount);

				if (amount > 0)
				{
					local ammo = this.new("scripts/items/supplies/ammo_item");
					ammo.setAmount(amount);
					loot.push(ammo);
				}
			}

			if (this.Tactical.Entities.getArmorParts() > 0 && this.World.Assets.m.IsRecoveringArmor)
			{
				local amount = this.Math.min(60, this.Math.max(1, this.Tactical.Entities.getArmorParts() * this.Const.World.Assets.ArmorPartsPerArmor * 0.15));
				amount = this.Math.rand(amount / 2, amount);

				if (amount > 0)
				{
					local parts = this.new("scripts/items/supplies/armor_parts_item");
					parts.setAmount(amount);
					loot.push(parts);
				}
			}
		}

		this.m.CombatResultLoot.assign(loot);
		this.m.CombatResultLoot.sort();
	}

	function gatherBrothers( _isVictory )
	{
		this.m.CombatResultRoster = [];
		this.Tactical.CombatResultRoster <- this.m.CombatResultRoster;
		local alive = this.Tactical.Entities.getAllInstancesAsArray();

		foreach( bro in alive )
		{
			if (bro.isAlive() && this.isKindOf(bro, "player"))
			{
				bro.onBeforeCombatResult();

				if (bro.isAlive() && !bro.isGuest() && bro.isPlayerControlled())
				{
					this.m.CombatResultRoster.push(bro);
				}
			}
		}

		local dead = this.Tactical.getCasualtyRoster().getAll();
		local survivor = this.Tactical.getSurvivorRoster().getAll();
		local retreated = this.Tactical.getRetreatRoster().getAll();
		local isArena = this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode;

		if (_isVictory || isArena)
		{
			foreach( s in survivor )
			{
				s.setIsAlive(true);
				s.onBeforeCombatResult();

				foreach( i, d in dead )
				{
					if (s.getID() == d.getOriginalID())
					{
						dead.remove(i);
						this.Tactical.getCasualtyRoster().remove(d);
						break;
					}
				}
			}

			this.m.CombatResultRoster.extend(survivor);
		}
		else
		{
			foreach( bro in survivor )
			{
				local fallen = {
					Name = bro.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, bro.getDaysWithCompany()),
					Kills = bro.getLifetimeStats().Kills,
					Battles = bro.getLifetimeStats().Battles,
					KilledBy = "Left to die",
					Expendable = bro.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.World.getPlayerRoster().remove(bro);
				bro.die();
			}
		}

		foreach( s in retreated )
		{
			s.onBeforeCombatResult();
		}

		this.m.CombatResultRoster.extend(retreated);
		this.m.CombatResultRoster.extend(dead);

		if (!this.isScenarioMode() && dead.len() > 1 && dead.len() >= this.m.CombatResultRoster.len() / 2)
		{
			this.updateAchievement("TimeToRebuild", 1, 1);
		}

		if (!this.isScenarioMode() && this.World.getPlayerRoster().getSize() == 0 && this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians) != null && this.m.Factions.getHostileFactionWithMostInstances() == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Barbarians).getID())
		{
			this.updateAchievement("GiveMeBackMyLegions", 1, 1);
		}
	}

	function init()
	{
		this.initOptions();

		if (this.m.Scenario != null)
		{
			this.m.Scenario.generate();
		}
		else
		{
			this.initMap();
		}

		this.Tactical.calculateTacticalValuesForTerrain();
		this.Tactical.createBlockedTileHighlights();

		if (this.Stash.isLocked() == false && this.m.Scenario != null)
		{
			this.m.CharacterScreen.setBattlePreparationMode();
			this.showCharacterScreen(true);
		}
		else
		{
			this.m.CharacterScreen.setGroundMode();
			this.Tactical.TurnSequenceBar.initNextRound();
		}

		this.Tactical.addResource("gfx/detail.png");
		local allEntities = this.Tactical.Entities.getAllInstances();

		foreach( f in allEntities )
		{
			foreach( e in f )
			{
				e.loadResources();
			}
		}

		if (this.m.StrategicProperties != null)
		{
			foreach( r in this.m.StrategicProperties.Ambience[0] )
			{
				this.Tactical.addResource("sounds/" + r.File);
			}

			foreach( r in this.m.StrategicProperties.Ambience[1] )
			{
				this.Tactical.addResource("sounds/" + r.File);
			}
		}

		if (this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode)
		{
			foreach( r in this.Const.Sound.ArenaNewRound )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in this.Const.Sound.ArenaHit )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in this.Const.Sound.ArenaHit )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in this.Const.Sound.ArenaBigHit )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in this.Const.Sound.ArenaKill )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in this.Const.Sound.ArenaMiss )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in this.Const.Sound.ArenaBigMiss )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in this.Const.Sound.ArenaShock )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in this.Const.Sound.ArenaFlee )
			{
				this.Tactical.addResource(r);
			}
		}

		if (!this.isScenarioMode() && this.World.FactionManager.isUndeadScourge())
		{
			local r1 = [
				"sounds/enemies/zombie_hurt_01.wav",
				"sounds/enemies/zombie_hurt_02.wav",
				"sounds/enemies/zombie_hurt_03.wav",
				"sounds/enemies/zombie_hurt_04.wav",
				"sounds/enemies/zombie_hurt_05.wav",
				"sounds/enemies/zombie_hurt_06.wav",
				"sounds/enemies/zombie_hurt_07.wav"
			];
			local r2 = [
				"sounds/enemies/zombie_death_01.wav",
				"sounds/enemies/zombie_death_02.wav",
				"sounds/enemies/zombie_death_03.wav",
				"sounds/enemies/zombie_death_04.wav",
				"sounds/enemies/zombie_death_05.wav",
				"sounds/enemies/zombie_death_06.wav"
			];
			local r3 = [
				"sounds/enemies/zombie_rise_01.wav",
				"sounds/enemies/zombie_rise_02.wav",
				"sounds/enemies/zombie_rise_03.wav",
				"sounds/enemies/zombie_rise_04.wav"
			];
			local r4 = [
				"sounds/enemies/zombie_idle_01.wav",
				"sounds/enemies/zombie_idle_02.wav",
				"sounds/enemies/zombie_idle_03.wav",
				"sounds/enemies/zombie_idle_04.wav",
				"sounds/enemies/zombie_idle_05.wav",
				"sounds/enemies/zombie_idle_06.wav",
				"sounds/enemies/zombie_idle_07.wav",
				"sounds/enemies/zombie_idle_08.wav",
				"sounds/enemies/zombie_idle_09.wav",
				"sounds/enemies/zombie_idle_10.wav",
				"sounds/enemies/zombie_idle_11.wav",
				"sounds/enemies/zombie_idle_12.wav",
				"sounds/enemies/zombie_idle_13.wav",
				"sounds/enemies/zombie_idle_14.wav",
				"sounds/enemies/zombie_idle_15.wav",
				"sounds/enemies/zombie_idle_16.wav"
			];
			local r5 = [
				"sounds/enemies/zombie_bite_01.wav",
				"sounds/enemies/zombie_bite_02.wav",
				"sounds/enemies/zombie_bite_03.wav",
				"sounds/enemies/zombie_bite_04.wav"
			];

			foreach( r in r1 )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in r2 )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in r3 )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in r4 )
			{
				this.Tactical.addResource(r);
			}

			foreach( r in r5 )
			{
				this.Tactical.addResource(r);
			}
		}

		this.Tactical.loadResources();
		this.show();
	}

	function spawnRetreatIcon( _tile )
	{
		local icon = _tile.spawnDetail("icon_fleeing", 0, false, false, this.createVec(15, 0));
		icon.Scale = 0.66;
		icon.Alpha = 84;
	}

	function initMap()
	{
		if (this.m.StrategicProperties.LocationTemplate != null && this.m.StrategicProperties.MapSeed != 0)
		{
			this.Math.seedRandom(this.m.StrategicProperties.MapSeed);
		}

		local map = this.MapGen.get(this.m.StrategicProperties.TerrainTemplate);
		local minX = map.getMinX();
		local minY = map.getMinY();
		this.Tactical.resizeScene(minX, minY);
		map.fill({
			X = 0,
			Y = 0,
			W = minX,
			H = minY
		}, this.m.StrategicProperties);

		if (this.m.StrategicProperties.LocationTemplate != null && this.m.StrategicProperties.LocationTemplate.Template[0] != null)
		{
			if (this.m.StrategicProperties.LocationTemplate.ForceLineBattle || this.m.StrategicProperties.LocationTemplate.Fortification == this.Const.Tactical.FortificationType.None)
			{
				this.m.StrategicProperties.LocationTemplate.ShiftX = 0;
				this.m.StrategicProperties.LocationTemplate.ShiftY = 0;
			}

			map.campify({
				X = 0,
				Y = 0,
				W = minX,
				H = minY
			}, this.m.StrategicProperties.LocationTemplate);
			local env0 = this.MapGen.get(this.m.StrategicProperties.LocationTemplate.Template[0]);
			env0.fill({
				X = 0,
				Y = 0,
				W = minX,
				H = minY
			}, this.m.StrategicProperties.LocationTemplate);
		}

		if (!this.m.StrategicProperties.IsFleeingProhibited)
		{
			local size = this.Tactical.getMapSize();

			for( local x = 0; x < size.X; x = ++x )
			{
				this.spawnRetreatIcon(this.Tactical.getTileSquare(x, 0));
			}

			for( local x = 0; x < size.X; x = ++x )
			{
				this.spawnRetreatIcon(this.Tactical.getTileSquare(x, size.Y - 1));
			}

			for( local y = 1; y < size.Y - 1; y = ++y )
			{
				this.spawnRetreatIcon(this.Tactical.getTileSquare(0, y));
			}

			for( local y = 1; y < size.Y - 1; y = ++y )
			{
				this.spawnRetreatIcon(this.Tactical.getTileSquare(size.X - 1, y));
			}
		}

		this.m.IsFogOfWarVisible = this.m.StrategicProperties.IsFogOfWarVisible;
		this.m.Factions.spawn(this.m.StrategicProperties);

		if (this.m.Scenario == null && !this.m.StrategicProperties.IsWithoutAmbience)
		{
			this.m.Factions.setupAmbience(this.m.StrategicProperties.Tile);
		}

		this.Tactical.getCamera().setLevelToHighestOnMap();
	}

	function initOptions()
	{
		this.initStatsOverlays();
		local settings = this.Settings.getControlSettings();
		this.m.UseDragStyleScrolling = settings.UseDragStyleScrolling;
	}

	function exitTactical()
	{
		this.m.IsBattleEnded = true;
		this.m.IsAIPaused = true;
		this.LoadingScreen.show();
	}

	function flee( _tag = null )
	{
		if (this.m.StrategicProperties != null && this.m.StrategicProperties.IsFleeingProhibited)
		{
			return;
		}

		if (this.isScenarioMode())
		{
			this.exitTactical();
			return;
		}

		this.m.IsAIPaused = true;
		this.m.IsFleeing = true;

		if (this.World.getPlayerRoster().getSize() != 0)
		{
			this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.PlayerRetreated);
		}
		else
		{
			this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.PlayerDestroyed);
		}

		this.Tactical.Entities.checkCombatFinished(true);
		this.onBattleEnded();
	}

	function isInLoadingScreen()
	{
		if (this.LoadingScreen != null && (this.LoadingScreen.isAnimating() || this.LoadingScreen.isVisible()))
		{
			return true;
		}

		return false;
	}

	function isInCharacterScreen()
	{
		if (this.m.CharacterScreen != null && (this.m.CharacterScreen.isVisible() || this.m.CharacterScreen.isAnimating()))
		{
			return true;
		}

		return false;
	}

	function isBattleEnded()
	{
		return this.Tactical.Entities.isCombatFinished();
	}

	function setActionStateByMouseEvent( _mouseEvent )
	{
		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

		if (activeEntity == null || this.Tactical.getNavigator().isTravelling(activeEntity) || this.isInputLocked())
		{
			return false;
		}

		switch(_mouseEvent.getID())
		{
		case 1:
			if (this.m.CurrentActionState == null)
			{
				this.computeEntityPath(activeEntity, _mouseEvent);
				return true;
			}
			else
			{
				switch(this.m.CurrentActionState)
				{
				case this.Const.Tactical.ActionState.ComputePath:
					this.executeEntityTravel(activeEntity, _mouseEvent);
					return true;

				case this.Const.Tactical.ActionState.SkillSelected:
					local tile = this.Tactical.getTile(this.Tactical.screenToTile(_mouseEvent.getX(), _mouseEvent.getY()));
					this.executeEntitySkill(activeEntity, tile);
					return true;
				}
			}

			return false;

		case 2:
			return this.cancelCurrentAction();

		case 3:
			break;
		}

		return false;
	}

	function setActionStateBySkillIndex( _skillIndex )
	{
		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

		if (activeEntity == null || this.isInputLocked())
		{
			this.logDebug("TurnSequenceBar::setActionStateBySkillId(No Active Entity | Enemy)");
			return;
		}

		local activeSkills = activeEntity.getSkills().queryActives();

		if (_skillIndex >= 0 && _skillIndex < activeSkills.len())
		{
			local skill = activeSkills[_skillIndex];

			if (skill == null)
			{
				this.logDebug("TurnSequenceBar::setActionStateBySkillIndex(No Skill selected)");
				return;
			}

			if (!skill.isUsable() || !skill.isAffordable())
			{
				this.Tactical.TurnSequenceBar.flashProgressbars(!skill.isAffordableBasedOnAP(), !skill.isAffordableBasedOnFatigue());

				if (!skill.isAffordable() && this.m.LastFatigueSoundTime + 3.0 < this.Time.getVirtualTimeF())
				{
					activeEntity.playSound(this.Const.Sound.ActorEvent.Fatigue, this.Const.Sound.Volume.Actor * activeEntity.m.SoundVolume[this.Const.Sound.ActorEvent.Fatigue]);
					this.m.LastFatigueSoundTime = this.Time.getVirtualTimeF();
				}

				return;
			}

			this.setActionStateBySkill(activeEntity, skill);
		}
	}

	function setActionStateBySkillId( _skillId )
	{
		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

		if (activeEntity == null || this.isInputLocked())
		{
			this.logDebug("TurnSequenceBar::setActionStateBySkillId(No Active Entity | Enemy)");
			return;
		}

		local skill = activeEntity.getSkills().getSkillByID(_skillId);

		if (skill == null)
		{
			this.logDebug("TurnSequenceBar::setActionStateBySkillId(No Skill selected)");
			return;
		}

		if (!skill.isUsable() || !skill.isAffordable())
		{
			this.Tactical.TurnSequenceBar.flashProgressbars(!skill.isAffordableBasedOnAP(), !skill.isAffordableBasedOnFatigue());
			return;
		}

		this.setActionStateBySkill(activeEntity, skill);
	}

	function setActionStateBySkill( _activeEntity, _skill )
	{
		if (this.m.IsGameFinishable && this.isBattleEnded())
		{
			return;
		}

		if (this.m.CurrentActionState != null)
		{
			switch(this.m.CurrentActionState)
			{
			case this.Const.Tactical.ActionState.ComputePath:
				this.cancelEntityPath(_activeEntity);
				break;

			case this.Const.Tactical.ActionState.TravelPath:
				this.logInfo("entity is currently travelling!");
				return;

			case this.Const.Tactical.ActionState.ExecuteSkill:
				this.logInfo("entity is currently executing a skill!");
				return;
			}
		}

		if (this.m.SelectedSkillID == _skill.getID() && this.m.CurrentActionState == this.Const.Tactical.ActionState.SkillSelected)
		{
			_skill.onTargetDeselected();
			this.cancelEntitySkill(_activeEntity);
		}
		else
		{
			this.m.SelectedSkillID = _skill.getID();
			this.m.CurrentActionState = this.Const.Tactical.ActionState.SkillSelected;
			this.Tactical.TurnSequenceBar.selectSkillById(_skill.getID(), true);
			this.Tactical.TurnSequenceBar.setActiveEntityCostsPreview({
				ActionPoints = _skill.getActionPointCost(),
				Fatigue = _skill.getFatigueCost(),
				SkillID = _skill.getID()
			});
			this.Tooltip.reload();

			if (!_skill.isTargeted())
			{
				this.executeEntitySkill(_activeEntity, _activeEntity.getTile());
			}
			else
			{
				this.Tactical.getHighlighter().clear();
				this.Tactical.getHighlighter().highlightRangeOfSkill(_skill, _activeEntity);

				if (!this.Cursor.isOverUI())
				{
					this.updateCursorAndTooltip(true);
				}
			}
		}
	}

	function computeEntityPath( _activeEntity, _mouseEvent )
	{
		if (this.m.IsGameFinishable && this.isBattleEnded() || this.wasInCameraMovementMode())
		{
			return;
		}

		this.m.LastTileSelected = this.Tactical.getTile(this.Tactical.screenToTile(_mouseEvent.getX(), _mouseEvent.getY()));

		if (!this.m.LastTileSelected.IsDiscovered || _activeEntity.getCurrentProperties().IsRooted)
		{
			this.Cursor.setCursor(this.Const.UI.Cursor.Denied);
			return;
		}

		if (this.m.LastTileSelected.ID == _activeEntity.getTile().ID)
		{
			this.Cursor.setCursor(this.Const.UI.Cursor.Denied);
			this.Tactical.getNavigator().clearVisualisation();
			this.Tactical.getHighlighter().clear();
			this.Tactical.TurnSequenceBar.resetActiveEntityCostsPreview();
			this.m.CurrentActionState = null;
			return;
		}

		this.m.CurrentActionState = this.Const.Tactical.ActionState.ComputePath;
		local settings = this.Tactical.getNavigator().createSettings();
		settings.ActionPointCosts = _activeEntity.getActionPointCosts();
		settings.FatigueCosts = _activeEntity.getFatigueCosts();
		settings.FatigueCostFactor = this.Const.Movement.FatigueCostFactor;
		settings.ActionPointCostPerLevel = _activeEntity.getLevelActionPointCost();
		settings.FatigueCostPerLevel = _activeEntity.getLevelFatigueCost();
		settings.ZoneOfControlCost = 4;
		settings.AlliedFactions = _activeEntity.getAlliedFactions();
		settings.Faction = _activeEntity.getFaction();
		settings.AllowZoneOfControlPassing = true;
		settings.IsPlayer = true;

		if (this.Tactical.getNavigator().findPath(_activeEntity.getTile(), this.m.LastTileSelected, settings, 0))
		{
			this.Cursor.setCursor(this.Const.UI.Cursor.Boot);
			this.Tactical.getNavigator().buildVisualisation(_activeEntity, settings, _activeEntity.getActionPoints(), _activeEntity.getFatigueMax() - _activeEntity.getFatigue());
			this.Tactical.getHighlighter().clear();
			this.Tactical.getHighlighter().highlightZoneOfControl(_activeEntity.getAlliedFactions());
			settings.ZoneOfControlCost = 0;
			local movementCosts = this.Tactical.getNavigator().getCostForPath(_activeEntity, settings, _activeEntity.getActionPoints(), _activeEntity.getFatigueMax() - _activeEntity.getFatigue());

			if (movementCosts.Tiles != 0)
			{
				this.Tactical.TurnSequenceBar.setActiveEntityCostsPreview(movementCosts);
			}
			else
			{
				this.Tactical.TurnSequenceBar.flashProgressbars(movementCosts.IsMissingActionPoints, movementCosts.IsMissingFatigue);
			}
		}
		else
		{
			this.Cursor.setCursor(this.Const.UI.Cursor.Denied);
			this.Tactical.getNavigator().clearVisualisation();
			this.Tactical.getHighlighter().clear();
			this.Tactical.TurnSequenceBar.resetActiveEntityCostsPreview();
			this.m.CurrentActionState = null;
		}
	}

	function cancelEntityPath( _activeEntity )
	{
		this.m.CurrentActionState = null;
		this.Tactical.getNavigator().clearPath();
		this.Tactical.getNavigator().clearVisualisation();
		this.Tactical.getHighlighter().clear();
		this.Tactical.TurnSequenceBar.resetActiveEntityCostsPreview();
		this.updateCursorAndTooltip();
	}

	function executeEntityTravel( _activeEntity, _mouseEvent )
	{
		if (this.wasInCameraMovementMode())
		{
			return;
		}

		local tile = this.Tactical.getTile(this.Tactical.screenToTile(_mouseEvent.getX(), _mouseEvent.getY()));

		if (this.Tactical.getNavigator().HasValidPath && this.m.LastTileSelected.X == tile.X && this.m.LastTileSelected.Y == tile.Y)
		{
			local movementCosts = this.Tactical.getNavigator().getCostForPath(_activeEntity, this.Tactical.getNavigator().getLastSettings(), _activeEntity.getActionPoints(), _activeEntity.getFatigueMax() - _activeEntity.getFatigue());

			if (movementCosts.Tiles != 0)
			{
				this.Cursor.setCursor(this.Const.UI.Cursor.Hourglass);
				this.m.CurrentActionState = this.Const.Tactical.ActionState.TravelPath;
				this.m.ActiveEntityNeedsUpdate = true;
				this.Tactical.getNavigator().clearVisualisation();
				this.Tactical.getHighlighter().clear();
				this.Tactical.getShaker().cancel(_activeEntity);

				if (this.Tactical.getCamera().Level < tile.Level)
				{
					this.Tactical.getCamera().Level = tile.Level;
				}
			}
		}
		else
		{
			this.computeEntityPath(_activeEntity, _mouseEvent);
		}
	}

	function executeEntitySkill( _activeEntity, _targetTile )
	{
		local skill = _activeEntity.getSkills().getSkillByID(this.m.SelectedSkillID);

		if (skill != null && skill.isUsable() && skill.isAffordable())
		{
			if (_targetTile == null || skill.isTargeted() && this.wasInCameraMovementMode())
			{
				return;
			}

			if (skill.isUsableOn(_targetTile))
			{
				if (!_targetTile.IsEmpty)
				{
					local targetEntity = _targetTile.getEntity();

					if (this.Tactical.getCamera().Level < _targetTile.Level)
					{
						this.Tactical.getCamera().Level = this.Tactical.getCamera().getBestLevelForTile(_targetTile);
					}

					if (this.isKindOf(targetEntity, "actor"))
					{
						this.logDebug("[" + _activeEntity.getName() + "] executes skill [" + skill.getName() + "] on target [" + targetEntity.getName() + "]");
					}
				}

				skill.use(_targetTile);

				if (_activeEntity.isAlive())
				{
					this.Tactical.TurnSequenceBar.updateEntity(_activeEntity.getID());
				}

				this.Tooltip.reload();
				this.Tactical.TurnSequenceBar.deselectActiveSkill();
				this.Tactical.getHighlighter().clear();
				this.m.CurrentActionState = null;
				this.m.SelectedSkillID = null;
				this.updateCursorAndTooltip();
			}
			else
			{
				this.Cursor.setCursor(this.Const.UI.Cursor.Denied);
				this.Tactical.EventLog.log("[color=" + this.Const.UI.Color.NegativeValue + "]Invalid target![/color]");
			}
		}
	}

	function cancelEntitySkill( _activeEntity )
	{
		this.Tactical.getHighlighter().clear();
		this.m.CurrentActionState = null;
		this.m.SelectedSkillID = null;
		this.Tactical.TurnSequenceBar.deselectActiveSkill();
		this.Tactical.TurnSequenceBar.resetActiveEntityCostsPreview();
		this.Tooltip.reload();
		this.updateCursorAndTooltip();
	}

	function cancelCurrentAction()
	{
		if (this.m.CurrentActionState != null)
		{
			local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

			switch(this.m.CurrentActionState)
			{
			case this.Const.Tactical.ActionState.ComputePath:
				this.cancelEntityPath(activeEntity);
				return true;

			case this.Const.Tactical.ActionState.SkillSelected:
				this.cancelEntitySkill(activeEntity);
				return true;
			}
		}

		return false;
	}

	function onProcessAI()
	{
		if (this.Tactical.State == null || this.Tactical.State.isBattleEnded())
		{
			return;
		}

		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

		if (activeEntity != null && activeEntity.getAIAgent().isEvaluating())
		{
			activeEntity.getAIAgent().think(true);
		}
	}

	function updateCurrentEntity()
	{
		if (this.m.IsGameFinishable && this.isBattleEnded())
		{
			return;
		}

		if (this.m.IsGamePaused)
		{
			return;
		}

		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

		if (activeEntity == null)
		{
			this.Tactical.TurnSequenceBar.initNextTurn();
			return;
		}

		activeEntity.onUpdate();

		if (!activeEntity.isPlayerControlled() || this.m.IsAutoRetreat)
		{
			this.setInputLocked(true);

			if (activeEntity.getAIAgent() != null)
			{
				if (!this.m.IsAIPaused)
				{
					local agent = activeEntity.getAIAgent();

					if (!this.Const.AI.ParallelizationMode || !agent.isEvaluating())
					{
						agent.think();
					}

					if (agent.isFinished() || !activeEntity.isAlive())
					{
						this.Tactical.TurnSequenceBar.initNextTurn();
					}
				}
			}
			else
			{
				this.Tactical.TurnSequenceBar.initNextTurn();
			}
		}
		else
		{
			local agent = activeEntity.getAIAgent();

			if (agent != null && !this.m.IsAIPaused)
			{
				if (!agent.isFinished())
				{
					this.setInputLocked(true);

					if (!this.Const.AI.ParallelizationMode || !agent.isEvaluating())
					{
						agent.think();
					}
				}
				else if (!activeEntity.isAlive() || activeEntity.getMoraleState() == this.Const.MoraleState.Fleeing)
				{
					this.Tactical.TurnSequenceBar.initNextTurn();
				}
				else
				{
					this.setInputLocked(false);
				}
			}
			else
			{
				this.setInputLocked(false);
			}

			if (!this.isInputLocked())
			{
				switch(this.m.CurrentActionState)
				{
				case this.Const.Tactical.ActionState.SkillSelected:
				case this.Const.Tactical.ActionState.ComputePath:
				case null:
					if (activeEntity.isTurnDone())
					{
						this.Tactical.TurnSequenceBar.initNextTurn();
					}
					else if (!this.Tactical.getNavigator().isTravelling(activeEntity) && !activeEntity.isPlayingRenderAnimation())
					{
						this.Tactical.getShaker().shake(activeEntity, activeEntity.getTile(), 1);
					}

					break;

				case this.Const.Tactical.ActionState.TravelPath:
					if (!this.Tactical.getNavigator().travel(activeEntity, activeEntity.getActionPoints(), activeEntity.getFatigueMax() - activeEntity.getFatigue()))
					{
						this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
						this.m.CurrentActionState = null;
						this.m.ActiveEntityNeedsUpdate = true;

						if (activeEntity.isAlive() && activeEntity.getTile().Level > this.Tactical.getCamera().Level)
						{
							this.Tactical.getCamera().Level = activeEntity.getTile().Level;
						}
					}

					if (activeEntity.isAlive() && this.m.ActiveEntityNeedsUpdate)
					{
						this.Tactical.TurnSequenceBar.updateEntity(activeEntity.getID());
						this.m.ActiveEntityNeedsUpdate = false;
					}

					break;
				}
			}
			else
			{
			}
		}
	}

	function updateOrientationOverlays()
	{
		this.Tactical.OrientationOverlay.update();
	}

	function renderOrientationOverlays()
	{
		this.Tactical.OrientationOverlay.render();
	}

	function updateCursorAndTooltip( _skillSelected = false )
	{
		local cursorX = this.Cursor.getX();
		local cursorY = this.Cursor.getY();

		if (this.Cursor.isOverUI())
		{
			if (this.m.LastTileHovered != null)
			{
				this.m.LastTileHovered = null;
				this.m.LastTileHoveredHadEntity = false;
			}

			if (!this.Cursor.wasOverUI())
			{
				this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			}

			return;
		}

		if (this.isInCameraMovementMode())
		{
			return;
		}

		local isValidSkill = false;
		local hoveredTile = this.Tactical.getTile(this.Tactical.screenToTile(cursorX, cursorY));
		local entity = this.Tactical.TurnSequenceBar.getActiveEntity();

		if (this.m.CurrentActionState == null && entity != null && entity.isPlayerControlled())
		{
			local cursorSet = false;

			if (!hoveredTile.IsEmpty && hoveredTile.IsDiscovered)
			{
				local tileEntity = hoveredTile.getEntity();

				if (!this.isKindOf(tileEntity, "actor") || !tileEntity.isHiddenToPlayer())
				{
					this.Cursor.setCursor(this.Const.UI.Cursor.Denied);
					cursorSet = true;
				}
			}

			if (!cursorSet)
			{
				this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			}
		}
		else
		{
			switch(this.m.CurrentActionState)
			{
			case this.Const.Tactical.ActionState.SkillSelected:
				if (entity != null)
				{
					local skill = entity.getSkills().getSkillByID(this.m.SelectedSkillID);

					if (skill == null || !skill.isUsable() || !skill.isAffordable() || !skill.onVerifyTarget(entity.getTile(), hoveredTile) || !skill.isInRange(hoveredTile) || !hoveredTile.IsVisibleForEntity || skill.isTargetingActor() && !hoveredTile.IsEmpty && !this.isKindOf(hoveredTile.getEntity(), "actor"))
					{
						this.Cursor.setCursor(this.Const.UI.Cursor.Denied);
					}
					else
					{
						this.Cursor.setCursor(skill.getCursorForTile(hoveredTile));
						isValidSkill = true;
					}
				}
				else
				{
					this.Cursor.setCursor(this.Const.UI.Cursor.Sword);
				}

				break;

			case this.Const.Tactical.ActionState.ComputePath:
				if ((hoveredTile.IsEmpty || !hoveredTile.IsVisibleForPlayer && this.isKindOf(hoveredTile.getEntity(), "actor")) && hoveredTile.Type != this.Const.Tactical.TerrainType.Impassable)
				{
					this.Cursor.setCursor(this.Const.UI.Cursor.Boot);
				}
				else
				{
					this.Cursor.setCursor(this.Const.UI.Cursor.Denied);
				}

				break;

			case this.Const.Tactical.ActionState.TravelPath:
				this.Cursor.setCursor(this.Const.UI.Cursor.Hourglass);
				break;

			default:
				this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
				break;
			}
		}

		if (this.m.LastTileHovered == null || this.m.LastTileHovered.ID != hoveredTile.ID && !this.isInCameraMovementMode())
		{
			this.Tactical.TurnSequenceBar.deselectEntity();

			if (!hoveredTile.IsEmpty)
			{
				local tileEntity = hoveredTile.getEntity();

				if (!tileEntity.isHiddenToPlayer() && this.isKindOf(tileEntity, "actor"))
				{
					this.Tactical.TurnSequenceBar.selectEntity(tileEntity);
				}
			}
		}

		if (this.m.LastTileHoveredHadEntity != null && this.m.LastTileHovered != null)
		{
			if (this.m.LastTileHoveredHadEntity == false && !this.m.LastTileHovered.IsEmpty || this.m.LastTileHoveredHadEntity != false && this.m.LastTileHovered.IsEmpty)
			{
				this.m.LastTileHovered = null;
				this.Tooltip.mouseLeaveTile();
			}
		}

		if ((this.m.LastTileHovered == null || !this.m.LastTileHovered.isSameTileAs(hoveredTile)) && !this.isInCameraMovementMode())
		{
			this.Tooltip.mouseLeaveTile();

			if (this.m.CurrentActionState == this.Const.Tactical.ActionState.SkillSelected)
			{
				local skill = entity.getSkills().getSkillByID(this.m.SelectedSkillID);

				if (skill != null)
				{
					skill.onTargetDeselected();
				}
			}

			this.m.LastTileHovered = hoveredTile;

			if (this.m.CurrentActionState == this.Const.Tactical.ActionState.SkillSelected && isValidSkill)
			{
				local skill = entity.getSkills().getSkillByID(this.m.SelectedSkillID);
				skill.onTargetSelected(hoveredTile);
			}

			if (!this.m.LastTileHovered.IsEmpty)
			{
				this.m.LastTileHoveredHadEntity = true;
				local tileEntity = this.m.LastTileHovered.getEntity();

				if (!tileEntity.isHiddenToPlayer() && this.isKindOf(tileEntity, "actor"))
				{
					this.Tooltip.mouseEnterTile(cursorX, cursorY, tileEntity.getID());
				}
				else
				{
					this.Tooltip.mouseEnterTile(cursorX, cursorY);
				}
			}
			else
			{
				this.m.LastTileHoveredHadEntity = false;
				this.Tooltip.mouseEnterTile(cursorX, cursorY);
			}
		}
		else
		{
			if (!this.isInCameraMovementMode())
			{
				this.Tooltip.mouseHoverTile(cursorX, cursorY);
			}

			if (this.m.CurrentActionState == this.Const.Tactical.ActionState.SkillSelected && isValidSkill && _skillSelected)
			{
				local skill = entity.getSkills().getSkillByID(this.m.SelectedSkillID);
				skill.onTargetSelected(hoveredTile);
			}
		}
	}

	function updateCamera( _mouseEvent )
	{
		if (this.m.UseDragStyleScrolling == true)
		{
			if (!this.Cursor.isOverUI())
			{
				if (_mouseEvent.getState() == 1)
				{
					if (_mouseEvent.getID() == 1)
					{
						this.resetCameraState();
					}
				}

				if (this.isInputLocked())
				{
					return true;
				}

				switch(_mouseEvent.getState())
				{
				case 0:
					if (!this.m.IsInCameraMovementMode && _mouseEvent.getID() == 1)
					{
						this.m.IsInCameraMovementMode = true;
						this.m.WasInCameraMovementMode = false;
						this.m.MouseDownPosition = {
							X = _mouseEvent.getX(),
							Y = _mouseEvent.getY()
						};
					}

					break;

				case 2:
					if (this.m.IsInCameraMovementMode && _mouseEvent.getID() == 6)
					{
						local xOffset = this.Math.abs(this.m.MouseDownPosition.X - _mouseEvent.getX());
						local yOffset = this.Math.abs(this.m.MouseDownPosition.Y - _mouseEvent.getY());

						if (xOffset > 0 || yOffset > 0)
						{
							if (!this.m.WasInCameraMovementMode && xOffset <= this.Const.Camera.MouseMoveThreshold && yOffset <= this.Const.Camera.MouseMoveThreshold)
							{
								return;
							}

							local camera = this.Tactical.getCamera();
							local newX = (this.m.MouseDownPosition.X - _mouseEvent.getX()) * camera.Zoom;
							local newY = -((this.m.MouseDownPosition.Y - _mouseEvent.getY()) * camera.Zoom);
							this.m.MouseDownPosition.X = _mouseEvent.getX();
							this.m.MouseDownPosition.Y = _mouseEvent.getY();
							this.m.WasInCameraMovementMode = true;
							camera.move(newX, newY);

							if (this.m.CursorBeforeCameraMovement == null)
							{
								this.m.CursorBeforeCameraMovement = this.Cursor.getCurrentCursor();
								this.Cursor.setHardwareCursor(false, true);
							}

							this.Cursor.setCursor(this.Const.UI.Cursor.Scroll);
						}
					}

					break;
				}
			}
			else
			{
				this.resetCameraState();
			}
		}
		else
		{
			this.m.ScrollDirectionX = 0;
			this.m.ScrollDirectionY = 0;

			if (this.Cursor.isOverUI())
			{
				return;
			}

			local currentVideoMode = this.Settings.getVideoMode();
			local distLeft = _mouseEvent.getX();
			local distTop = _mouseEvent.getY();
			local distRight = this.Math.abs(currentVideoMode.Width - _mouseEvent.getX());
			local distBottom = this.Math.abs(currentVideoMode.Height - _mouseEvent.getY());

			if (distLeft < this.Const.Camera.MouseScrollThreshold)
			{
				this.m.ScrollDirectionX = -(this.Const.Camera.MouseScrollThreshold - distLeft);
			}
			else if (distRight < this.Const.Camera.MouseScrollThreshold)
			{
				this.m.ScrollDirectionX = this.Const.Camera.MouseScrollThreshold - distRight;
			}

			if (distTop < this.Const.Camera.MouseScrollThreshold)
			{
				this.m.ScrollDirectionY = this.Const.Camera.MouseScrollThreshold - distTop;
			}
			else if (distBottom < this.Const.Camera.MouseScrollThreshold)
			{
				this.m.ScrollDirectionY = -(this.Const.Camera.MouseScrollThreshold - distBottom);
			}

			local camera = this.Tactical.getCamera();
			this.m.ScrollDirectionX = this.m.ScrollDirectionX * this.Const.Camera.MouseScrollFactor * camera.Zoom;
			this.m.ScrollDirectionY = this.m.ScrollDirectionY * this.Const.Camera.MouseScrollFactor * camera.Zoom;
		}
	}

	function updateCameraScrolling()
	{
		if (this.m.UseDragStyleScrolling || (this.m.ScrollDirectionX == null || this.m.ScrollDirectionY == null) || this.m.ScrollDirectionX == 0 && this.m.ScrollDirectionY == 0)
		{
			return;
		}

		local camera = this.Tactical.getCamera();
		local delta = this.Time.getDelta();

		if (!this.isInputLocked())
		{
			camera.move(this.m.ScrollDirectionX * delta, this.m.ScrollDirectionY * delta);
		}
	}

	function resetCameraState()
	{
		if (this.m.IsInCameraMovementMode)
		{
			this.m.IsInCameraMovementMode = false;
			this.m.MouseDownPosition = null;
			this.Cursor.setHardwareCursor(true);

			if (this.m.CursorBeforeCameraMovement != null)
			{
				this.Cursor.setCursor(this.m.CursorBeforeCameraMovement);
				this.m.CursorBeforeCameraMovement = null;
			}

			this.m.LastTileHovered = null;
			this.updateCursorAndTooltip();
		}
	}

	function onBattleEnded()
	{
		if (this.m.IsExitingToMenu)
		{
			return;
		}

		this.m.IsBattleEnded = true;
		local isVictory = this.Tactical.Entities.getCombatResult() == this.Const.Tactical.CombatResult.EnemyDestroyed || this.Tactical.Entities.getCombatResult() == this.Const.Tactical.CombatResult.EnemyRetreated;
		this.m.IsFogOfWarVisible = false;
		this.Tactical.fillVisibility(this.Const.Faction.Player, true);
		this.Tactical.getCamera().zoomTo(2.0, 1.0);
		this.Tooltip.hide();
		this.m.TacticalScreen.hide();
		this.Tactical.OrientationOverlay.removeOverlays();

		if (isVictory)
		{
			this.Music.setTrackList(this.Const.Music.VictoryTracks, this.Const.Music.CrossFadeTime);

			if (!this.isScenarioMode())
			{
				if (this.m.StrategicProperties != null && this.m.StrategicProperties.IsAttackingLocation)
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictoryVSLocation);
				}
				else
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnVictory);
				}

				this.World.Contracts.onCombatVictory(this.m.StrategicProperties != null ? this.m.StrategicProperties.CombatID : "");
				this.World.Events.onCombatVictory(this.m.StrategicProperties != null ? this.m.StrategicProperties.CombatID : "");
				this.World.Statistics.getFlags().set("LastEnemiesDefeatedCount", this.m.MaxHostiles);
				this.World.Statistics.getFlags().set("LastCombatResult", 1);

				if (this.World.Statistics.getFlags().getAsInt("LastCombatFaction") == this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID())
				{
					this.World.Statistics.getFlags().increment("BeastsDefeated");
				}

				local playerRoster = this.World.getPlayerRoster().getAll();

				foreach( bro in playerRoster )
				{
					if (bro.getPlaceInFormation() <= 17 && !bro.isPlacedOnMap() && bro.getFlags().get("Devoured") == true)
					{
						bro.onDeath(null, null, null, this.Const.FatalityType.Devoured);
						this.World.getPlayerRoster().remove(bro);
					}
					else if (this.m.StrategicProperties.IsUsingSetPlayers && bro.isPlacedOnMap())
					{
						bro.getLifetimeStats().BattlesWithoutMe = 0;

						if (this.m.StrategicProperties.IsArenaMode)
						{
							bro.improveMood(this.Const.MoodChange.BattleWon, "A gagné un combat dans l\'arène");
						}
						else
						{
							bro.improveMood(this.Const.MoodChange.BattleWon, "A gagné une bataille");
						}
					}
					else if (!this.m.StrategicProperties.IsUsingSetPlayers)
					{
						if (bro.getPlaceInFormation() <= 17)
						{
							bro.getLifetimeStats().BattlesWithoutMe = 0;
							bro.improveMood(this.Const.MoodChange.BattleWon, "A gagné une bataille");
						}
						else if (bro.getMoodState() > this.Const.MoodState.Concerned && !bro.getCurrentProperties().IsContentWithBeingInReserve && !this.World.Assets.m.IsDisciplined)
						{
							++bro.getLifetimeStats().BattlesWithoutMe;

							if (bro.getLifetimeStats().BattlesWithoutMe > this.Math.max(2, 6 - bro.getLevel()))
							{
								bro.worsenMood(this.Const.MoodChange.BattleWithoutMe, "Felt useless in reserve");
							}
						}
					}
				}
			}
		}
		else
		{
			this.Music.setTrackList(this.Const.Music.DefeatTracks, this.Const.Music.CrossFadeTime);

			if (!this.isScenarioMode())
			{
				local playerRoster = this.World.getPlayerRoster().getAll();

				foreach( bro in playerRoster )
				{
					if (bro.getPlaceInFormation() <= 17 && !bro.isPlacedOnMap() && bro.getFlags().get("Devoured") == true)
					{
						if (bro.isAlive())
						{
							bro.onDeath(null, null, null, this.Const.FatalityType.Devoured);
							this.World.getPlayerRoster().remove(bro);
						}
					}
					else if (bro.getPlaceInFormation() <= 17 && bro.isPlacedOnMap() && (bro.getFlags().get("Charmed") == true || bro.getFlags().get("Sleeping") == true || bro.getFlags().get("Nightmare") == true))
					{
						if (bro.isAlive())
						{
							bro.kill(null, null, this.Const.FatalityType.Suicide);
						}
					}
					else if (bro.getPlaceInFormation() <= 17)
					{
						bro.getLifetimeStats().BattlesWithoutMe = 0;

						if (this.Tactical.getCasualtyRoster().getSize() != 0)
						{
							bro.worsenMood(this.Const.MoodChange.BattleLost, "A perdu une bataille");
						}
						else if (this.World.Assets.getOrigin().getID() != "scenario.deserters")
						{
							bro.worsenMood(this.Const.MoodChange.BattleRetreat, "S\'est retiré de la bataille");
						}
					}
					else if (bro.getMoodState() > this.Const.MoodState.Concerned && !bro.getCurrentProperties().IsContentWithBeingInReserve && !this.World.Assets.m.IsDisciplined)
					{
						++bro.getLifetimeStats().BattlesWithoutMe;

						if (bro.getLifetimeStats().BattlesWithoutMe > this.Math.max(2, 6 - bro.getLevel()))
						{
							bro.worsenMood(this.Const.MoodChange.BattleWithoutMe, "Se sens inutile en réserve");
						}
					}
				}

				if (this.World.getPlayerRoster().getSize() != 0)
				{
					this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnLoss);
					this.World.Contracts.onRetreatedFromCombat(this.m.StrategicProperties != null ? this.m.StrategicProperties.CombatID : "");
					this.World.Events.onRetreatedFromCombat(this.m.StrategicProperties != null ? this.m.StrategicProperties.CombatID : "");
					this.World.Statistics.getFlags().set("LastEnemiesDefeatedCount", 0);
					this.World.Statistics.getFlags().set("LastCombatResult", 2);
				}
			}
		}

		if (this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode)
		{
			this.Sound.play(this.Const.Sound.ArenaEnd[this.Math.rand(0, this.Const.Sound.ArenaEnd.len() - 1)], this.Const.Sound.Volume.Tactical);
			this.Time.scheduleEvent(this.TimeUnit.Real, 4500, function ( _t )
			{
				this.Sound.play(this.Const.Sound.ArenaOutro[this.Math.rand(0, this.Const.Sound.ArenaOutro.len() - 1)], this.Const.Sound.Volume.Tactical);
			}, null);
		}

		this.gatherBrothers(isVictory);
		this.gatherLoot();
		this.Time.scheduleEvent(this.TimeUnit.Real, 800, this.onBattleEndedDelayed.bindenv(this), isVictory);
	}

	function onBattleEndedDelayed( _isVictory )
	{
		if (this.m.MenuStack.hasBacksteps())
		{
			this.Time.scheduleEvent(this.TimeUnit.Real, 50, this.onBattleEndedDelayed.bindenv(this), _isVictory);
			return;
		}

		if (this.m.IsGameFinishable)
		{
			this.Tooltip.hide();
			this.m.TacticalCombatResultScreen.show();
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			this.m.MenuStack.push(function ()
			{
				if (this.m.TacticalCombatResultScreen != null)
				{
					if (_isVictory && !this.Tactical.State.isScenarioMode() && this.m.StrategicProperties != null && (!this.m.StrategicProperties.IsLootingProhibited || this.m.StrategicProperties.IsArenaMode && !this.m.CombatResultLoot.isEmpty()) && this.Settings.getGameplaySettings().AutoLoot)
					{
						this.m.TacticalCombatResultScreen.onLootAllItemsButtonPressed();
						this.World.Assets.consumeItems();
						this.World.Assets.refillAmmo();
						this.World.Assets.updateAchievements();
						this.World.Assets.checkAmbitionItems();
						this.World.State.updateTopbarAssets();
					}

					this.m.TacticalScreen.show();
					this.m.TacticalCombatResultScreen.hide();
				}
			}, function ()
			{
				return false;
			});
		}
	}

	function showCharacterScreen( _forced = false )
	{
		if (this.m.CharacterScreen.isAnimating())
		{
			return;
		}

		if (!_forced && (this.Tactical.TurnSequenceBar.getActiveEntity() == null || !this.Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled()))
		{
			return;
		}

		if (!this.m.CharacterScreen.isVisible() && !this.m.MenuStack.hasBacksteps())
		{
			this.cancelCurrentAction();
			this.setPause(true);
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			this.m.CharacterScreen.show();
			this.m.TacticalScreen.hide();
		}

		if (this.m.CharacterScreen.isInBattlePreparationMode())
		{
			this.LoadingScreen.hide();
		}
	}

	function hideCharacterScreen( _isExitState = false )
	{
		if (this.m.CharacterScreen.isAnimating())
		{
			return;
		}

		if (this.m.CharacterScreen.isVisible())
		{
			this.m.CharacterScreen.hide();

			if (_isExitState == false)
			{
				this.m.TacticalScreen.show();
			}

			this.Stash.setLocked(true);
			this.setPause(false);

			if (this.m.CharacterScreen.isInBattlePreparationMode())
			{
				this.m.CharacterScreen.setGroundMode();

				if (this.m.Scenario != null)
				{
					this.Music.setTrackList(this.m.Scenario.getMusic(), this.Const.Sound.CrossFadeTime);
				}

				this.Tactical.TurnSequenceBar.initNextRound();
			}
			else if (this.Tactical.TurnSequenceBar.getActiveEntity() != null)
			{
				this.Tactical.TurnSequenceBar.updateEntity(this.Tactical.TurnSequenceBar.getActiveEntity().getID());
			}
		}
	}

	function initStatsOverlays()
	{
		local settings = this.Settings.getGameplaySettings();
		local tempSettings = this.Settings.getTempGameplaySettings();
		tempSettings.ShowOverlayStats = settings.ShowOverlayStats;
		tempSettings.HideTrees = settings.AlwaysHideTrees;
		local ob = this.m.TacticalScreen.getTopbarOptionsModule();
		ob.setToggleStatsOverlaysButtonState(tempSettings.ShowOverlayStats);
		ob.setToggleTreesButtonState(!tempSettings.HideTrees);
		ob.setToggleHighlightBlockedTilesListenerButtonState(tempSettings.HighlightBlockedTiles);
	}

	function onCameraMovementStart()
	{
		this.Tooltip.hide();
	}

	function onCameraMovementEnd()
	{
	}

	function tacticalscreen_onConnected()
	{
		this.init();
	}

	function topbar_options_onToggleHighlightBlockedTilesButtonClicked()
	{
		if (!this.isInputLocked())
		{
			local settings = this.Settings.getTempGameplaySettings();
			settings.HighlightBlockedTiles = !settings.HighlightBlockedTiles;
			this.Tactical.setBlockedTileHighlightsVisibility(settings.HighlightBlockedTiles);
			local ob = this.m.TacticalScreen.getTopbarOptionsModule();
			ob.setToggleHighlightBlockedTilesListenerButtonState(settings.HighlightBlockedTiles);
		}
	}

	function topbar_options_onCenterButtonClicked()
	{
		if (!this.isInputLocked())
		{
			this.Tactical.TurnSequenceBar.focusActiveEntity(true);
		}
	}

	function topbar_options_onSwitchMapLevelUpButtonClicked()
	{
		this.Tactical.getCamera().climbBy(1);
	}

	function topbar_options_onSwitchMapLevelDownButtonClicked()
	{
		this.Tactical.getCamera().climbBy(-1);
	}

	function topbar_options_onToggleStatsOverlaysButtonClicked()
	{
		local settings = this.Settings.getTempGameplaySettings();
		settings.ShowOverlayStats = !settings.ShowOverlayStats;
		local ob = this.m.TacticalScreen.getTopbarOptionsModule();
		ob.setToggleStatsOverlaysButtonState(settings.ShowOverlayStats);
	}

	function topbar_options_onToggleTreesButtonClicked()
	{
		local settings = this.Settings.getTempGameplaySettings();
		settings.HideTrees = !settings.HideTrees;
		local ob = this.m.TacticalScreen.getTopbarOptionsModule();
		ob.setToggleTreesButtonState(!settings.HideTrees);
	}

	function topbar_options_onFleeButtonClicked()
	{
		if (this.m.IsEnemyRetreatDialogShown)
		{
			return this.showRetreatScreen();
		}
		else if (!this.m.IsAutoRetreat)
		{
			if (this.m.StrategicProperties != null && this.m.StrategicProperties.IsFleeingProhibited)
			{
				return;
			}

			return this.showFleeScreen();
		}
	}

	function topbar_options_onQuitButtonClicked()
	{
		return this.toggleMenuScreen();
	}

	function turnsequencebar_onNextTurn()
	{
		if (this.Tactical.getNavigator().IsTravelling)
		{
			return false;
		}

		this.m.CurrentActionState = null;
		this.Tactical.getNavigator().clearPath();
		this.Tactical.getNavigator().clearVisualisation();
		this.Tactical.getHighlighter().clear();
		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);

		if (this.m.IsExitingToMenu)
		{
			this.m.IsBattleEnded = true;
			this.m.IsAIPaused = true;
			this.setPause(true);
			this.LoadingScreen.show();
			return true;
		}

		return true;
	}

	function turnsequencebar_onNextRound( _round )
	{
		this.logDebug("INFO: Next round issued: " + _round);
		this.Time.setRound(_round);

		if (this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode)
		{
			if (_round == 1)
			{
				this.Sound.play(this.Const.Sound.ArenaStart[this.Math.rand(0, this.Const.Sound.ArenaStart.len() - 1)], this.Const.Sound.Volume.Tactical);
			}
			else
			{
				this.Sound.play(this.Const.Sound.ArenaNewRound[this.Math.rand(0, this.Const.Sound.ArenaNewRound.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
			}
		}
		else
		{
			this.Sound.play(this.Const.Sound.NewRound[this.Math.rand(0, this.Const.Sound.NewRound.len() - 1)], this.Const.Sound.Volume.Tactical);
		}

		this.Tactical.clearVisibility();

		if (!this.m.IsFogOfWarVisible)
		{
			this.Tactical.fillVisibility(this.Const.Faction.Player, true);
			this.Tactical.fillVisibility(this.Const.Faction.PlayerAnimals, true);
		}

		local heroes = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

		foreach( hero in heroes )
		{
			hero.updateVisibilityForFaction();
		}

		local pets = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.PlayerAnimals);

		foreach( pet in pets )
		{
			pet.updateVisibilityForFaction();
		}

		this.Tactical.Entities.updateTileEffects();
		this.Tactical.TopbarRoundInformation.update();
		this.m.MaxHostiles = this.Math.max(this.m.MaxHostiles, this.Tactical.Entities.getHostilesNum());
	}

	function turnsequencebar_onCheckEnemyRetreat()
	{
		if (this.Time.getRound() >= 2 && !this.Tactical.Entities.isCombatFinished() && !this.m.IsAutoRetreat)
		{
			this.Tactical.Entities.checkEnemyRetreating();

			if (!this.m.IsEnemyRetreatDialogShown && (this.m.StrategicProperties == null || !this.m.StrategicProperties.IsFleeingProhibited) && this.Tactical.Entities.isEnemyRetreating() && !this.m.MenuStack.hasBacksteps() && !this.m.CharacterScreen.isVisible() && !this.m.CharacterScreen.isAnimating() && !this.m.TacticalMenuScreen.isVisible() && !this.m.TacticalMenuScreen.isAnimating() && !this.m.TacticalDialogScreen.isVisible() && !this.m.TacticalDialogScreen.isAnimating())
			{
				this.m.IsEnemyRetreatDialogShown = true;
				this.showRetreatScreen();
			}
			else
			{
				this.Tactical.TurnSequenceBar.setBusy(false);
			}
		}
		else
		{
			this.Tactical.TurnSequenceBar.setBusy(false);
		}
	}

	function turnsequencebar_onEntitySkillClicked( _skillId )
	{
		this.setActionStateBySkillId(_skillId);
	}

	function turnsequencebar_onEntitySkillCancelClicked( _skillId )
	{
		local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

		if (activeEntity == null || this.isInputLocked())
		{
			return;
		}

		local skill = activeEntity.getSkills().getSkillByID(_skillId);

		if (skill == null || !skill.isUsable() || !skill.isAffordable())
		{
			return;
		}

		this.cancelEntitySkill(activeEntity);
	}

	function turnsequencebar_onEntityEnteredFirstSlot( _entity )
	{
		if (this.Tactical.TurnSequenceBar.getCurrentRound() == 1 && this.LoadingScreen.isVisible() && !this.LoadingScreen.isAnimating())
		{
			this.LoadingScreen.hide();
		}

		if (!_entity.isPlayerControlled())
		{
			this.setInputLocked(true);
		}
		else
		{
			this.setInputLocked(false);
		}
	}

	function turnsequencebar_onEntityEnteredFirstSlotFully( _entity )
	{
		if (_entity.isPlayerControlled())
		{
			this.setInputLocked(false);
		}
	}

	function turnsequencebar_onEntityMouseEnter( _entity )
	{
		if (_entity != null && _entity.isAlive())
		{
			_entity.showArrow(true);
		}
	}

	function turnsequencebar_onEntityMouseLeave( _entity )
	{
		if (_entity != null && _entity.isAlive())
		{
			_entity.showArrow(false);
		}
	}

	function topbar_round_information_onQueryRoundInformation()
	{
		return {
			brothersCount = this.Tactical.Entities.getAlliesNum(),
			enemiesCount = this.Tactical.Entities.getHostilesNum(),
			roundNumber = this.Tactical.TurnSequenceBar.getCurrentRound()
		};
	}

	function showDialogPopup( _title, _text, _okCallback, _cancelCallback )
	{
		if (this.m.TacticalDialogScreen.isVisible() || this.m.TacticalDialogScreen.isAnimating())
		{
			return;
		}

		if (!this.DialogScreen.isVisible() && !this.DialogScreen.isAnimating())
		{
			this.DialogScreen.show(_title, _text, this.onDialogHidden.bindenv(this), _okCallback, _cancelCallback);
			this.m.TacticalScreen.hide();
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			this.m.MenuStack.push(function ()
			{
				this.DialogScreen.hide();

				if (!this.isBattleEnded())
				{
					this.m.TacticalScreen.show();
				}
			}, function ()
			{
				return !this.DialogScreen.isAnimating();
			});
		}
	}

	function onDialogHidden()
	{
		this.m.MenuStack.pop();
	}

	function tactical_combat_result_screen_onLeavePressed()
	{
		this.exitTactical();
	}

	function tactical_combat_result_screen_onQueryCombatInformation()
	{
		local rounds = this.Tactical.TurnSequenceBar.getCurrentRound();
		local isWin = this.Tactical.Entities.getCombatResult() == this.Const.Tactical.CombatResult.EnemyDestroyed || this.Tactical.Entities.getCombatResult() == this.Const.Tactical.CombatResult.EnemyRetreated;
		local isArena = this.m.StrategicProperties != null && this.m.StrategicProperties.IsArenaMode;
		local isLooting = isWin && (this.m.StrategicProperties == null || !this.m.StrategicProperties.IsLootingProhibited) || isArena && !this.m.CombatResultLoot.isEmpty();
		local result = {
			result = isWin ? "win" : "loose",
			loot = isLooting,
			arena = isArena,
			title = "",
			subTitle = ""
		};

		switch(this.Tactical.Entities.getCombatResult())
		{
		case this.Const.Tactical.CombatResult.EnemyDestroyed:
			result.title = "Victoire";
			result.subTitle = "L\'ennemi a été détruit en " + rounds + " tour" + (rounds > 1 ? "s" : "");
			break;

		case this.Const.Tactical.CombatResult.EnemyRetreated:
			result.title = "Victoire";
			result.subTitle = "L\'ennemi a battu en retraite après " + rounds + " tour" + (rounds > 1 ? "s" : "");
			break;

		case this.Const.Tactical.CombatResult.PlayerDestroyed:
			result.title = "Défaite";
			result.subTitle = "Vous avez perdu après " + rounds + " tour" + (rounds > 1 ? "s" : "");
			break;

		case this.Const.Tactical.CombatResult.PlayerRetreated:
			result.title = "Retraite";
			result.subTitle = "Vous avez battu en retraite après " + rounds + " tour" + (rounds > 1 ? "s" : "");

			if (!this.isScenarioMode())
			{
				this.updateAchievement("ToFightAnotherDay", 1, 1);
			}

			break;
		}

		return result;
	}

	function isEveryoneSafe()
	{
		local alive = this.Tactical.Entities.getAllInstancesAsArray();
		local isEveryoneAtEdges = true;

		foreach( bro in alive )
		{
			if (bro.isAlive() && this.isKindOf(bro, "player"))
			{
				local tile = bro.getTile();

				if (tile.SquareCoords.X >= 1 && tile.SquareCoords.Y >= 1 && tile.SquareCoords.X <= this.Tactical.getMapSize().X - 1 && tile.SquareCoords.Y <= this.Tactical.getMapSize().Y - 1)
				{
					isEveryoneAtEdges = false;
					break;
				}
			}
		}

		if (isEveryoneAtEdges)
		{
			return true;
		}

		return false;
	}

	function showFleeScreen( _tag = null )
	{
		this.setPause(true);
		this.Tooltip.hide();
		this.m.TacticalScreen.hide();
		this.m.TacticalDialogScreen.show("Retraite du Combat", "Etes-vous sûr ?", this.Const.Strings.UI.FleeDialogueConsequences, "Retraite !", "Annuler", this.tactical_flee_screen_onFleePressed.bindenv(this), this.tactical_flee_screen_onCancelPressed.bindenv(this));
		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
		this.m.MenuStack.push(function ()
		{
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			this.setPause(this.m.IsFleeing);
			this.m.IsShowingFleeScreen = false;

			if (!this.m.IsFleeing)
			{
				this.m.TacticalDialogScreen.hide();
				this.m.TacticalScreen.show();
			}
		}, function ()
		{
			return !this.m.TacticalDialogScreen.isAnimating();
		});
		return true;
	}

	function tactical_flee_screen_onFleePressed()
	{
		this.Sound.play("sounds/retreat_01.wav", 0.75);

		if (this.isScenarioMode() || this.isEveryoneSafe())
		{
			this.m.IsFleeing = true;
			this.m.MenuStack.pop();
			this.m.TacticalDialogScreen.hide();
			this.m.TacticalScreen.hide();
			this.Time.clearEvents();
			this.setPause(true);
			this.flee();
		}
		else if (!this.m.IsAutoRetreat)
		{
			this.m.IsAutoRetreat = true;
			this.m.MenuStack.pop();
			this.Settings.getTempGameplaySettings().FasterPlayerMovement = true;
			this.Settings.getTempGameplaySettings().FasterAIMovement = true;
			this.Tactical.getCamera().zoomTo(this.Math.maxf(this.Tactical.getCamera().Zoom, 1.5), 1.0);
			this.Time.setVirtualSpeed(1.5);
			local alive = this.Tactical.Entities.getAllInstancesAsArray();

			foreach( bro in alive )
			{
				if (bro.isAlive() && this.isKindOf(bro, "player"))
				{
					if (bro.getSkills().hasSkill("effects.charmed"))
					{
						local agent = bro.getSkills().getSkillByID("effects.charmed").m.OriginalAgent;
						agent.setUseHeat(true);
						agent.getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 1.0;
					}
					else
					{
						bro.getAIAgent().setUseHeat(true);
						bro.getAIAgent().getProperties().BehaviorMult[this.Const.AI.Behavior.ID.Retreat] = 1.0;
					}

					this.Tactical.TurnSequenceBar.updateEntity(bro.getID());
				}
			}

			local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();

			if (activeEntity != null && activeEntity.isPlayerControlled())
			{
				activeEntity.getAIAgent().setFinished(false);
			}

			this.updateCurrentEntity();
		}
	}

	function tactical_flee_screen_onCancelPressed()
	{
		this.m.MenuStack.pop();
		this.m.TacticalDialogScreen.hide();
		this.m.TacticalScreen.show();
	}

	function showRetreatScreen( _tag = null )
	{
		this.setPause(true);
		this.Tooltip.hide();
		this.m.TacticalScreen.hide();
		this.m.TacticalDialogScreen.show("L\'ennemi bat en retraite", "", this.Const.Strings.UI.RetreatDialogueConsequences, "C\'est fini", "Écrasez-les !", this.tactical_retreat_screen_onYesPressed.bindenv(this), this.tactical_retreat_screen_onNoPressed.bindenv(this));
		this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
		this.m.MenuStack.push(function ()
		{
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			this.m.IsShowingFleeScreen = false;
			this.setPause(false);
			this.Tactical.TurnSequenceBar.setBusy(false);
		}, function ()
		{
			return !this.m.TacticalDialogScreen.isAnimating();
		});
		return true;
	}

	function tactical_retreat_screen_onYesPressed()
	{
		this.Tactical.Entities.makeAllHostilesRetreat();
		this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyRetreated);
		this.Tactical.Entities.checkCombatFinished(true);
		this.m.MenuStack.pop();
		this.m.TacticalDialogScreen.hide();
	}

	function tactical_retreat_screen_onNoPressed()
	{
		this.m.MenuStack.pop();
		this.m.TacticalDialogScreen.hide();
		this.m.TacticalScreen.show();
	}

	function toggleMenuScreen()
	{
		if (this.m.IsFleeing)
		{
			return;
		}

		local hasBacksteps = this.m.MenuStack.hasBacksteps();

		if (!hasBacksteps)
		{
			if (this.cancelCurrentAction())
			{
				return true;
			}

			local allowRetreat = this.m.StrategicProperties == null || !this.m.StrategicProperties.IsFleeingProhibited;
			local allowQuit = !this.isScenarioMode();
			this.setPause(true);
			this.Tooltip.hide();
			this.m.TacticalScreen.hide();
			this.m.TacticalMenuScreen.show(allowRetreat, allowQuit, !this.isScenarioMode() && this.World.Assets.isIronman() ? "Quitter et Prendre sa retraite" : "Quitter");
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
			this.m.MenuStack.push(function ()
			{
				this.m.TacticalMenuScreen.hide();

				if (!this.m.IsShowingFleeScreen)
				{
					this.m.TacticalScreen.show();
				}

				this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
				this.setPause(false);
			}, function ()
			{
				return !this.m.TacticalMenuScreen.isAnimating();
			});
			return true;
		}
		else
		{
			this.m.MenuStack.pop();
			return true;
		}
	}

	function main_menu_module_onOptionsPressed()
	{
		this.m.TacticalMenuScreen.showOptionsMenu();
		this.m.MenuStack.push(function ()
		{
			this.m.TacticalMenuScreen.hideOptionsMenu();
		}, function ()
		{
			return !this.m.TacticalMenuScreen.isAnimating();
		});
	}

	function main_menu_module_onFleePressed()
	{
		this.Time.clearEvents();

		if (this.isScenarioMode() || this.m.StrategicProperties != null && this.m.StrategicProperties.IsFleeingProhibited)
		{
			this.Time.scheduleEvent(this.TimeUnit.Real, 300, this.flee.bindenv(this), null);
			this.m.MenuStack.pop();
		}
		else if (this.m.IsEnemyRetreatDialogShown)
		{
			this.m.IsShowingFleeScreen = true;
			this.m.MenuStack.pop();
			this.showRetreatScreen();
		}
		else if (!this.m.IsAutoRetreat)
		{
			this.m.IsShowingFleeScreen = true;
			this.m.MenuStack.pop();
			this.showFleeScreen();
		}
	}

	function main_menu_module_onResumePressed()
	{
		this.m.MenuStack.pop();
	}

	function options_menu_module_onOkPressed()
	{
		this.initOptions();
		this.m.MenuStack.pop();
	}

	function options_menu_module_onCancelPressed()
	{
		this.m.MenuStack.pop();
	}

	function initLoadingScreenHandler()
	{
		this.LoadingScreen.clearEventListener();
		this.LoadingScreen.setOnScreenShownListener(this.loading_screen_onScreenShown.bindenv(this));
		this.LoadingScreen.setOnQueryDataListener(this.loading_screen_onQueryData.bindenv(this));
	}

	function isInLoadingScreen()
	{
		if (this.LoadingScreen != null && (this.LoadingScreen.isAnimating() || this.LoadingScreen.isVisible()))
		{
			return true;
		}

		return false;
	}

	function loading_screen_onScreenShown()
	{
		if (this.m.IsExitingToMenu)
		{
			if (this.isScenarioMode())
			{
				this.sendMessageToSiblings("ExitToMenu");
			}
			else
			{
				this.sendMessageToSiblings("QuitToMenu");
			}
		}
		else
		{
			this.sendMessageToSiblings("AboutToFinish");
		}
	}

	function loading_screen_onQueryData()
	{
		return {
			imagePath = this.Const.LoadingScreens[this.Math.rand(0, this.Const.LoadingScreens.len() - 1)],
			text = this.Const.TipOfTheDay[this.Math.rand(0, this.Const.TipOfTheDay.len() - 1)]
		};
	}

	function helper_activateSkillByKey( _key )
	{
		local key = _key.getKey();
		local index = -1;

		if (key == 1 || key == 56)
		{
			index = 0;
		}
		else if (key == 2 || key == 57)
		{
			index = 1;
		}
		else if (key == 3 || key == 58)
		{
			index = 2;
		}
		else if (key == 4 || key == 59)
		{
			index = 3;
		}
		else if (key == 5 || key == 60)
		{
			index = 4;
		}
		else if (key == 6 || key == 61)
		{
			index = 5;
		}
		else if (key == 7 || key == 62)
		{
			index = 6;
		}
		else if (key == 8 || key == 63)
		{
			index = 7;
		}
		else if (key == 9 || key == 64)
		{
			index = 8;
		}
		else if (key == 10 || key == 55)
		{
			index = 9;
		}
		else
		{
			index = -1;
		}

		if (index != -1)
		{
			if (_key.getModifier() == 1)
			{
				index = index + 10;
			}

			this.setActionStateBySkillIndex(index);
		}
	}

	function helper_handleDeveloperKeyInput( _key )
	{
		if (_key.getState() != 0)
		{
			return false;
		}

		switch(_key.getKey())
		{
		case 21:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.Tactical.getNavigator().IsTravelling)
			{
				break;
			}

			if (this.m.LastTileHovered != null && !this.m.LastTileHovered.IsEmpty)
			{
				local entity = this.m.LastTileHovered.getEntity();

				if (entity != null && this.isKindOf(entity, "actor"))
				{
					this.logDebug("Kill entity: " + entity.getName());

					if (entity == this.Tactical.TurnSequenceBar.getActiveEntity())
					{
						this.cancelEntityPath(entity);
					}

					entity.die();
					return true;
				}
			}

			break;

		case 22:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.Tactical.getNavigator().IsTravelling)
			{
				break;
			}

			if (this.m.LastTileHovered != null && !this.m.LastTileHovered.IsEmpty)
			{
				local entity = this.m.LastTileHovered.getEntity();

				if (entity != null && this.isKindOf(entity, "actor"))
				{
					this.logDebug("Kill entity: " + entity.getName());

					if (entity == this.Tactical.TurnSequenceBar.getActiveEntity())
					{
						this.cancelEntityPath(entity);
					}

					entity.killSilently();
					return true;
				}
			}

			break;

		case 18:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null)
			{
				this.m.LastTileHovered.clear(this.Const.Tactical.DetailFlag.Corpse);
			}

			break;

		case 15:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.Tactical.getNavigator().IsTravelling)
			{
				break;
			}

			if (this.m.LastTileHovered != null && !this.m.LastTileHovered.IsEmpty)
			{
				local entity = this.m.LastTileHovered.getEntity();

				if (entity != null && this.isKindOf(entity, "actor"))
				{
					entity.getSkills().add(this.new("scripts/skills/effects/chilled_effect"));
					return true;
				}
			}

			break;

		case 25:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Goblins : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getID());
				e.assignRandomEquipment();
			}

			break;

		case 9:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/goblin_fighter");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Undead : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
				e.assignRandomEquipment();
			}

			break;

		case 8:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/goblin_ambusher");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Undead : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
				e.assignRandomEquipment();
			}

			break;

		case 33:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/nomad_leader");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Bandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getID());
				e.makeMiniboss();
				e.assignRandomEquipment();
			}

			break;

		case 11:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null)
			{
				for( local i = 0; i < this.Const.Tactical.HandgonneRightParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.HandgonneRightParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, this.m.LastTileHovered, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}

			break;

		case 30:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			this.Time.setVirtualSpeed(0.1);
			break;

		case 36:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			this.Time.setVirtualSpeed(1.0);
			break;

		case 31:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/objective/greenskin_catapult");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Orcs : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
				e.assignRandomEquipment();
			}

			break;

		case 20:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/noble_arbalester");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Civilian : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
				e.assignRandomEquipment();
			}

			break;

		case 29:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/flying_skull");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
				e.assignRandomEquipment();
			}

			break;

		case 23:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/zombie");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Undead : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
				e.assignRandomEquipment();
			}

			break;

		case 24:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/lindwurm");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Undead : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
				e.assignRandomEquipment();
			}

			break;

		case 53:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/sand_golem");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Beasts : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
				e.assignRandomEquipment();
			}

			break;

		case 54:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e;

				if (this.Math.rand(0, 1) == 0)
				{
					e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/hyena");
				}
				else
				{
					e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/hyena_high");
				}

				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Beasts : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
				e.assignRandomEquipment();
			}

			break;

		case 45:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/serpent");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Beasts : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
				e.assignRandomEquipment();
			}

			break;

		case 72:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/nomad_cutthroat");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
				e.assignRandomEquipment();
			}

			break;

		case 73:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/nomad_outlaw");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
				e.assignRandomEquipment();
			}

			break;

		case 74:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e;
				e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/nomad_slinger");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
				e.assignRandomEquipment();
			}

			break;

		case 75:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/nomad_archer");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
				e.assignRandomEquipment();
			}

			break;

		case 76:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/conscript");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalCityState).getID());
				e.assignRandomEquipment();
			}

			break;

		case 77:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/gunner");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalCityState).getID());
				e.assignRandomEquipment();
			}

			break;

		case 78:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/objective/mortar");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalCityState).getID());
				e.assignRandomEquipment();
			}

			break;

		case 79:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/engineer");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalCityState).getID());
				e.assignRandomEquipment();
			}

			break;

		case 80:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/officer");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalCityState).getID());
				e.assignRandomEquipment();
			}

			break;

		case 44:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/humans/assassin");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.OrientalBandits : this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalCityState).getID());
				e.assignRandomEquipment();
			}

			break;

		case 81:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.Tooltip.getDelay() < 1000)
			{
				this.Tooltip.setDelay(900000);
			}
			else
			{
				this.Tooltip.setDelay(150);
			}

			break;

		case 44:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/enemies/bandit_marksman");
				e.setFaction(this.isScenarioMode() ? this.Const.Faction.Beasts : this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
				e.assignRandomEquipment();
			}

			break;

		case 34:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/player");
				this.World.getPlayerRoster().add(e);
				e.setFaction(this.Const.Faction.Player);
				e.setScenarioValues();
				e.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
				e.assignRandomMeleeEquipment();
			}

			break;

		case 35:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/player");
				this.World.getPlayerRoster().add(e);
				e.setFaction(this.Const.Faction.Player);
				e.setScenarioValues();
				e.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
				e.assignRandomRangedEquipment();
			}

			break;

		case 32:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				local e = this.Tactical.spawnEntity("scripts/entity/tactical/player");
				e.setFaction(this.Const.Faction.Player);
				e.setScenarioValues();
				e.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
				e.assignRandomThrowingEquipment();
			}

			break;
			break;

		case 27:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
				this.m.LastTileHovered.clear(1);
			}

			break;

		case 16:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			this.m.IsFogOfWarVisible = !this.m.IsFogOfWarVisible;

			if (this.m.IsFogOfWarVisible)
			{
				this.Tactical.fillVisibility(this.Const.Faction.Player, false);
				local heroes = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);

				foreach( i, hero in heroes )
				{
					hero.updateVisibilityForFaction();
				}

				if (this.Tactical.TurnSequenceBar.getActiveEntity() != null)
				{
					this.Tactical.TurnSequenceBar.getActiveEntity().updateVisibilityForFaction();
				}
			}
			else
			{
				this.Tactical.fillVisibility(this.Const.Faction.Player, true);
			}

			break;

		case 26:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			this.m.IsAIPaused = !this.m.IsAIPaused;

			if (this.m.IsAIPaused)
			{
				this.logDebug("*** AI PAUSED ***");
			}
			else
			{
				this.logDebug("*** AI RESUMED ***");
			}

			break;

		case 12:
			if (!this.m.IsDeveloperModeEnabled)
			{
				break;
			}

			if (this.m.LastTileHovered != null && !this.m.LastTileHovered.IsEmpty)
			{
				local s = this.new("scripts/skills/effects/bleeding_effect");
				s.setDamage(100);
				this.m.LastTileHovered.getEntity().getSkills().add(s);
			}

			break;

		case 17:
			if (!this.m.IsDeveloperModeEnabled)
			{
			}
			else
			{
				if (this.m.LastTileHovered != null && !this.m.LastTileHovered.IsEmpty)
				{
					if ("grow" in this.m.LastTileHovered.getEntity())
					{
						this.m.LastTileHovered.getEntity().grow();
					}
				}

				break;
				break;
			}
		}

		return false;
	}

	function helper_handleContextualKeyInput( _key )
	{
		if (this.isInLoadingScreen())
		{
			return true;
		}

		if (this.helper_handleDeveloperKeyInput(_key))
		{
			return true;
		}

		if (this.isBattleEnded())
		{
			return true;
		}

		if (_key.getState() == 0)
		{
			if (this.isInCharacterScreen())
			{
				switch(_key.getKey())
				{
				case 39:
					if (_key.getModifier() == 1)
					{
						return false;
					}

					if (this.m.CharacterScreen.isInBattlePreparationMode() == true)
					{
						this.hideCharacterScreen();
					}

					break;

				case 11:
				case 48:
					this.m.CharacterScreen.switchToPreviousBrother();
					break;

				case 38:
				case 14:
				case 50:
					this.m.CharacterScreen.switchToNextBrother();
					break;

				case 19:
				case 13:
				case 41:
					this.hideCharacterScreen();
					break;
				}

				return true;
			}
			else
			{
				if (_key.getKey() == 41)
				{
					if (!this.m.MenuStack.hasBacksteps() || this.m.TacticalMenuScreen.isVisible())
					{
						if (this.toggleMenuScreen())
						{
							return true;
						}
					}
				}

				if (this.m.MenuStack.hasBacksteps())
				{
					return false;
				}

				switch(_key.getKey())
				{
				case 97:
					this.topbar_options_onToggleStatsOverlaysButtonClicked();
					return true;

				case 30:
					this.topbar_options_onToggleTreesButtonClicked();
					return true;

				case 12:
					this.topbar_options_onToggleHighlightBlockedTilesButtonClicked();
					return true;

				case 14:
					if ((_key.getModifier() & 2) != 0 && this.m.IsAllowingDeveloperMode)
					{
						this.m.IsDeveloperModeEnabled = !this.m.IsDeveloperModeEnabled;

						if (this.m.IsDeveloperModeEnabled)
						{
							this.logDebug("*** DEVELOPER MODE ENABLED ***");
						}
						else
						{
							this.logDebug("*** DEVELOPER MODE DISABLED ***");
						}
					}

					break;
				}

				if (this.isInputLocked())
				{
					return true;
				}

				switch(_key.getKey())
				{
				case 16:
					if (this.m.IsDeveloperModeEnabled)
					{
						break;
					}

				case 39:
					if (!(_key.getModifier() == 1))
					{
						this.Tactical.TurnSequenceBar.initNextTurn();
						return true;
					}

					break;

				case 28:
					if (!(_key.getModifier() == 1))
					{
						this.Tactical.TurnSequenceBar.onEndTurnAllButtonPressed();
						return true;
					}

					break;

				case 44:
				case 40:
					if (!(_key.getModifier() == 1))
					{
						if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled())
						{
							local wasAbleToWait = this.Tactical.TurnSequenceBar.entityWaitTurn(this.Tactical.TurnSequenceBar.getActiveEntity());

							if (!wasAbleToWait)
							{
								this.Tactical.TurnSequenceBar.initNextTurn();
							}
						}

						return true;
					}

					break;

				case 96:
					this.Tactical.TurnSequenceBar.focusActiveEntity(true);
					return true;

				case 19:
				case 13:
					this.showCharacterScreen();
					return true;
				}
			}
		}

		if (_key.getState() == 1)
		{
			if (this.isInputLocked() || this.isInCharacterScreen() || this.m.IsDeveloperModeEnabled || this.m.MenuStack.hasBacksteps())
			{
				return false;
			}

			switch(_key.getKey())
			{
			case 11:
			case 27:
			case 48:
				if (_key.getModifier() != 2)
				{
					this.Tactical.getCamera().move(-1500.0 * this.Time.getDelta(), 0);
					return true;
				}

				break;

			case 14:
			case 50:
				if (_key.getModifier() != 2)
				{
					this.Tactical.getCamera().move(1500.0 * this.Time.getDelta(), 0);
					return true;
				}

				break;

			case 33:
			case 36:
			case 49:
				if (_key.getModifier() != 2)
				{
					this.Tactical.getCamera().move(0, 1500.0 * this.Time.getDelta());
					return true;
				}

				break;

			case 29:
			case 51:
				if (_key.getModifier() != 2)
				{
					this.Tactical.getCamera().move(0, -1500.0 * this.Time.getDelta());
					return true;
				}

				break;

			case 46:
				this.Tactical.getCamera().zoomBy(-this.Time.getDelta() * this.Math.max(60, this.Time.getFPS()) * 0.15);
				break;

			case 47:
				this.Tactical.getCamera().zoomBy(this.Time.getDelta() * this.Math.max(60, this.Time.getFPS()) * 0.15);
				break;
			}
		}

		if (_key.getState() == 0 && !this.m.MenuStack.hasBacksteps())
		{
			this.helper_activateSkillByKey(_key);
		}
	}

});

