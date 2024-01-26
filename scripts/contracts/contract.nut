this.contract <- {
	m = {
		ID = 0,
		Type = "",
		Name = "",
		Faction = 0,
		EmployerID = 0,
		Home = null,
		Origin = null,
		SituationID = 0,
		DifficultyMult = 1.0,
		PaymentMult = 1.0,
		Screens = [],
		States = [],
		ActiveScreen = null,
		ActiveState = null,
		Flags = null,
		TempFlags = null,
		UnitsSpawned = [],
		BulletpointsObjectives = [],
		BulletpointsPayment = [],
		TimeOut = 0.0,
		Payment = {
			Annoyance = 0,
			Pool = 0.0,
			Advance = 0.0,
			Completion = 0.0,
			Count = 0.0,
			MaxCount = 0,
			IsNegotiating = false,
			IsFinal = false,
			function getInAdvance()
			{
				local n = this.Math.round(this.Pool * this.Advance * this.Const.Contracts.Settings.PaymentInAdvanceMult * 0.1);
				return n * 10;
			}

			function getOnCompletion()
			{
				local n = this.Math.round(this.Pool * this.Completion * this.Const.Contracts.Settings.PaymentOnCompletionMult * 0.1);
				return n * 10;
			}

			function getPerCount()
			{
				local n = this.Math.round(this.Pool * this.Count * this.Const.Contracts.Settings.PaymentPerHeadMult);
				return n;
			}

		},
		IsValid = true,
		IsActive = false,
		IsStarted = false,
		IsNegotiated = false,
		IsDifficultyHidden = false,
		HasBigButtons = false,
		MakeAllSpawnsAttackableByAIOnceDiscovered = false,
		MakeAllSpawnsResetOrdersOnceDiscovered = false,
		MakeAllSpawnsResetOrdersOnContractEnd = true
	},
	function getID()
	{
		return this.m.ID;
	}

	function getType()
	{
		return this.m.Type;
	}

	function getTitle()
	{
		return this.buildText(this.m.Name);
	}

	function getName()
	{
		return this.m.Name;
	}

	function getFaction()
	{
		return this.m.Faction;
	}

	function getCharacter()
	{
		return this.Tactical.getEntityByID(this.m.EmployerID);
	}

	function getBanner()
	{
		return "ui/banners/factions/banner_" + (this.World.FactionManager.getFaction(this.m.Faction).getBanner() < 10 ? "0" + this.World.FactionManager.getFaction(this.m.Faction).getBanner() : this.World.FactionManager.getFaction(this.m.Faction).getBanner()) + "s";
	}

	function getHome()
	{
		return this.m.Home;
	}

	function getOrigin()
	{
		return this.m.Origin;
	}

	function getDifficultyMult()
	{
		return this.m.DifficultyMult;
	}

	function getPaymentMult()
	{
		return this.m.PaymentMult * this.m.DifficultyMult * this.World.Assets.m.ContractPaymentMult;
	}

	function getPayment()
	{
		return this.m.Payment;
	}

	function getSituationID()
	{
		return this.m.SituationID;
	}

	function getEmployer()
	{
		return this.Tactical.getEntityByID(this.m.EmployerID);
	}

	function getActiveState()
	{
		return this.m.ActiveState;
	}

	function getActiveScreen()
	{
		return this.m.ActiveScreen;
	}

	function isActive()
	{
		return this.m.IsActive;
	}

	function isStarted()
	{
		return this.m.IsStarted;
	}

	function isTimedOut()
	{
		return !this.m.IsActive && this.m.TimeOut != 0 && this.m.TimeOut <= this.Time.getVirtualTimeF();
	}

	function isNegotiated()
	{
		return this.m.IsNegotiated;
	}

	function hasBigButtons()
	{
		return this.m.HasBigButtons;
	}

	function setActive( _f )
	{
		this.m.IsActive = _f;
	}

	function setFaction( _f )
	{
		this.m.Faction = _f;
	}

	function setHome( _h )
	{
		if (typeof _h == "instance")
		{
			this.m.Home = _h;
		}
		else
		{
			this.m.Home = this.WeakTableRef(_h);
		}

		this.onHomeSet();
	}

	function setOrigin( _h )
	{
		if (typeof _h == "instance")
		{
			this.m.Origin = _h;
		}
		else
		{
			this.m.Origin = this.WeakTableRef(_h);
		}

		this.onOriginSet();
	}

	function setEmployerID( _id )
	{
		this.m.EmployerID = _id;
	}

	function create()
	{
		local r;

		if (this.World.getTime().Days < 5)
		{
			r = this.Math.rand(1, 30);
		}
		else if (this.World.getTime().Days < 10)
		{
			r = this.Math.rand(1, 75);
		}
		else
		{
			r = this.Math.rand(1, 100);
		}

		if (r <= 30)
		{
			this.m.DifficultyMult = this.Math.rand(70, 85) * 0.01;
		}
		else if (r <= 80)
		{
			this.m.DifficultyMult = this.Math.rand(95, 105) * 0.01;
		}
		else
		{
			this.m.DifficultyMult = this.Math.rand(115, 135) * 0.01;
		}

		this.m.PaymentMult = this.Math.rand(90, 110) * 0.01;
		this.m.Flags = this.new("scripts/tools/tag_collection");
		this.m.TempFlags = this.new("scripts/tools/tag_collection");
		this.createStates();
		this.createScreens();
	}

	function createStates()
	{
	}

	function createScreens()
	{
	}

	function update()
	{
		if (this.m.ActiveState == null)
		{
			return;
		}

		this.updateSpawnedUnits();

		if ("update" in this.m.ActiveState)
		{
			this.m.ActiveState.update();
		}
	}

	function start()
	{
		this.m.IsStarted = true;

		if (this.m.Home == null)
		{
			this.setHome(this.World.State.getCurrentTown());
		}

		if (this.m.Origin == null)
		{
			this.setOrigin(this.World.State.getCurrentTown());
		}

		this.onImportIntro();

		if (this.hasState("Offer"))
		{
			this.setState("Offer");
		}
	}

	function getScreen( _id )
	{
		if (typeof _id == "table" || typeof _id == "instance")
		{
			return _id;
		}

		foreach( s in this.m.Screens )
		{
			if (s.ID == _id)
			{
				return s;
			}
		}

		this.logError("Screen \"" + _id + "\" not found for contract \"" + this.m.Type + "\".");
		return null;
	}

	function getState( _id )
	{
		if (typeof _id == "table" || typeof _id == "instance")
		{
			return _id;
		}

		foreach( s in this.m.States )
		{
			if (s.ID == _id)
			{
				return s;
			}
		}

		this.logError("State \"" + _id + "\" not found for contract \"" + this.m.Type + "\".");
		return null;
	}

	function hasState( _id )
	{
		foreach( s in this.m.States )
		{
			if (s.ID == _id)
			{
				return true;
			}
		}

		return false;
	}

	function processInput( _option )
	{
		if (this.m.ActiveScreen == null)
		{
			return false;
		}

		if (_option >= this.m.ActiveScreen.Options.len())
		{
			return true;
		}

		local result = this.m.ActiveScreen.Options[_option].getResult();

		if (typeof result != "string" && result <= 0)
		{
			if (this.isActive())
			{
				this.setScreen(null);
			}

			return false;
		}

		this.setScreen(this.getScreen(result));
		return true;
	}

	function setScreen( _screen, _restartIfAlreadyActive = true )
	{
		if (_screen == null)
		{
			this.m.ActiveScreen = null;
			return;
		}

		if (typeof _screen == "string")
		{
			_screen = this.getScreen(_screen);
		}

		local oldID = "";

		if (this.m.ActiveScreen != null)
		{
			oldID = this.m.ActiveScreen.ID;
		}

		this.m.ActiveScreen = clone _screen;
		this.m.ActiveScreen.Contract <- this;
		this.m.ActiveScreen.Flags <- this.m.Flags;
		this.m.ActiveScreen.TempFlags <- this.m.TempFlags;
		this.m.ActiveScreen.Options = [];

		foreach( o in _screen.Options )
		{
			local option = {
				Text = o.Text,
				getResult = o.getResult
			};
			this.m.ActiveScreen.Options.push(option);
		}

		if ("List" in this.m.ActiveScreen)
		{
			this.m.ActiveScreen.List = [];
		}

		if ("Characters" in this.m.ActiveScreen)
		{
			this.m.ActiveScreen.Characters = [];
		}

		if (("start" in this.m.ActiveScreen) && (_restartIfAlreadyActive || this.m.ActiveScreen.ID != oldID))
		{
			this.m.ActiveScreen.start();
		}

		this.m.ActiveScreen.Title = this.buildText(this.m.ActiveScreen.Title);
		this.m.ActiveScreen.Text = this.buildText(this.m.ActiveScreen.Text);

		foreach( option in this.m.ActiveScreen.Options )
		{
			option.Contract <- this;
			option.Flags <- this.m.Flags;
			option.TempFlags <- this.m.TempFlags;
			option.Text <- this.buildText(option.Text);
		}
	}

	function setState( _state )
	{
		if (_state == null)
		{
			return;
		}

		if (typeof _state == "string")
		{
			_state = this.getState(_state);
		}

		if (this.m.ActiveState != null && "end" in this.m.ActiveState)
		{
			this.m.ActiveState.end();
		}

		this.m.ActiveState = _state;
		this.m.ActiveState.Contract <- this;
		this.m.ActiveState.Flags <- this.m.Flags;
		this.m.ActiveState.TempFlags <- this.m.TempFlags;

		if ("start" in this.m.ActiveState)
		{
			this.m.ActiveState.start();
		}

		this.World.Contracts.updateActiveContract();
	}

	function buildText( _text )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local brother1;
		local brother2;
		local notnagel;
		local slaves = [];

		for( local i = 0; i < brothers.len(); i = ++i )
		{
			if (brothers[i].getSkills().hasSkill("trait.player"))
			{
				notnagel = brothers[i];

				if (brothers.len() > 1)
				{
					brothers.remove(i);
				}
			}
			else if (brothers.len() > 1 && brothers[i].getBackground().getID() == "background.slave")
			{
				slaves.push(brothers[i]);
				brothers.remove(i);
			}
		}

		local r = this.Math.rand(0, brothers.len() - 1);
		brother1 = brothers[r].getName();
		brothers.remove(r);

		if (brothers.len() != 0)
		{
			brother2 = brothers[this.Math.rand(0, brothers.len() - 1)].getName();
		}
		else if (slaves.len() != 0)
		{
			brother2 = slaves[this.Math.rand(0, slaves.len() - 1)].getName();
		}
		else if (notnagel != null)
		{
			brother2 = notnagel.getName();
		}
		else
		{
			brother2 = brother1;
		}

		local villages = this.World.EntityManager.getSettlements();
		local randomTown;

		do
		{
			randomTown = villages[this.Math.rand(0, villages.len() - 1)].getNameOnly();
		}
		while (randomTown == null || randomTown == this.m.Home.getNameOnly());

		local text;
		local vars = [
			[
				"SPEECH_ON",
				"\n\n[color=#bcad8c]\""
			],
			[
				"SPEECH_START",
				"[color=#bcad8c]\""
			],
			[
				"SPEECH_OFF",
				"\"[/color]\n\n"
			],
			[
				"companyname",
				this.World.Assets.getName()
			],
			[
				"randomname",
				this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]
			],
			[
				"randomnoble",
				this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)]
			],
			[
				"randombrother",
				brother1
			],
			[
				"randombrother2",
				brother2
			],
			[
				"randomtown",
				randomTown
			],
			[
				"reward_completion",
				this.m.Payment.getOnCompletion()
			],
			[
				"reward_advance",
				this.m.Payment.getInAdvance()
			],
			[
				"reward_count",
				this.m.Payment.getPerCount()
			],
			[
				"employer",
				this.m.EmployerID != 0 ? this.Tactical.getEntityByID(this.m.EmployerID).getName() : ""
			],
			[
				"faction",
				this.World.FactionManager.getFaction(this.m.Faction).getName()
			],
			[
				"townname",
				this.m.Home.getName()
			],
			[
				"produce",
				this.m.Home.getProduceAsString()
			],
			[
				"origin",
				this.m.Origin.getName()
			],
			[
				"maxcount",
				this.m.Payment.MaxCount
			]
		];
		this.onPrepareVariables(vars);
		vars.push([
			"reward",
			this.m.Payment.getOnCompletion() + this.m.Payment.getInAdvance()
		]);
		return this.buildTextFromTemplate(_text, vars);
	}

	function onImportIntro()
	{
		this.importSettlementIntro();
	}

	function getUITitle()
	{
		if (this.m.ActiveScreen && "Title" in this.m.ActiveScreen)
		{
			return this.m.ActiveScreen.Title;
		}
		else
		{
			return this.m.Name;
		}
	}

	function getUIButtons()
	{
		local buttons = [];

		foreach( i, option in this.m.ActiveScreen.Options )
		{
			buttons.push({
				id = i,
				text = option.Text
			});
		}

		return buttons;
	}

	function getUIContent()
	{
		local result = [];
		result.push({
			id = 1,
			type = "description",
			text = this.m.ActiveScreen.Text
		});
		return result;
	}

	function getUIDifficultySmall()
	{
		if (this.m.DifficultyMult < 0.9)
		{
			return "ui/icons/difficulty_easy";
		}
		else if (this.m.DifficultyMult >= 0.9 && this.m.DifficultyMult <= 1.1)
		{
			return "ui/icons/difficulty_medium";
		}
		else if (this.m.DifficultyMult > 1.1)
		{
			return "ui/icons/difficulty_hard";
		}
	}

	function getUIList()
	{
		local ret = [];

		if (this.m.ActiveScreen.List.len() != 0)
		{
			local list = {
				title = "",
				items = this.m.ActiveScreen.List,
				fixed = false
			};
			ret.push(list);
		}

		if (("ShowObjectives" in this.m.ActiveScreen) && this.m.ActiveScreen.ShowObjectives)
		{
			ret.extend(this.getUIBulletpoints(true, false));
		}

		if (("ShowPayment" in this.m.ActiveScreen) && this.m.ActiveScreen.ShowPayment)
		{
			ret.extend(this.getUIBulletpoints(false, true));
		}

		return ret;
	}

	function getUIImage()
	{
		return this.m.ActiveScreen.Image;
	}

	function getUICharacterImage( _index = 0 )
	{
		if (("Characters" in this.m.ActiveScreen) && this.m.ActiveScreen.Characters.len() > _index)
		{
			return {
				Image = this.m.ActiveScreen.Characters[_index],
				IsProcedural = true
			};
		}
		else if (("Banner" in this.m.ActiveScreen) && _index > 0)
		{
			return {
				Image = this.m.ActiveScreen.Banner,
				IsProcedural = false
			};
		}
		else if (("ShowEmployer" in this.m.ActiveScreen) && this.m.ActiveScreen.ShowEmployer)
		{
			if (_index == 0)
			{
				return {
					Image = this.Tactical.getEntityByID(this.m.EmployerID).getImagePath(),
					IsProcedural = true
				};
			}
			else if (this.World.FactionManager.getFaction(this.m.Faction).getType() == this.Const.FactionType.NobleHouse)
			{
				return {
					Image = this.getBanner() + ".png",
					IsProcedural = false
				};
			}
			else
			{
				return null;
			}
		}
		else
		{
			return null;
		}
	}

	function getUIMiddleOverlay()
	{
		if (("ShowDifficulty" in this.m.ActiveScreen) && this.m.ActiveScreen.ShowDifficulty)
		{
			if (this.m.DifficultyMult < 0.9)
			{
				return {
					Image = "ui/images/difficulty_easy.png",
					IsProcedural = false
				};
			}
			else if (this.m.DifficultyMult >= 0.9 && this.m.DifficultyMult <= 1.1)
			{
				return {
					Image = "ui/images/difficulty_medium.png",
					IsProcedural = false
				};
			}
			else if (this.m.DifficultyMult > 1.1)
			{
				return {
					Image = "ui/images/difficulty_hard.png",
					IsProcedural = false
				};
			}
		}
		else
		{
			return null;
		}
	}

	function getUIBulletpoints( _objectives = true, _payment = true )
	{
		local ret = [];

		if (_objectives && this.m.BulletpointsObjectives.len() != 0)
		{
			local r = {
				title = "Objectifs",
				items = [],
				fixed = true
			};

			foreach( i, b in this.m.BulletpointsObjectives )
			{
				r.items.push({
					icon = "ui/icons/money.png",
					text = this.buildText(b)
				});
			}

			ret.push(r);
		}

		if (_payment && this.m.BulletpointsPayment.len() != 0)
		{
			local r = {
				title = "Paiement",
				items = [],
				fixed = true
			};

			foreach( i, b in this.m.BulletpointsPayment )
			{
				r.items.push({
					icon = "ui/icons/money.png",
					text = this.buildText(b)
				});
			}

			ret.push(r);
		}

		return ret;
	}

	function isValid()
	{
		if (!this.m.IsValid)
		{
			return false;
		}

		if (this.Tactical.getEntityByID(this.m.EmployerID) == null)
		{
			return false;
		}

		if (this.World.FactionManager.getFaction(this.getFaction()).getSettlements().len() == 0)
		{
			return false;
		}

		if (this.m.Home != null && (this.m.Home.isNull() || !this.m.Home.isAlive()))
		{
			return false;
		}

		if (this.m.Origin != null && (this.m.Origin.isNull() || !this.m.Origin.isAlive()))
		{
			return false;
		}

		return this.onIsValid();
	}

	function isTileUsed( _tile )
	{
		if (_tile == null)
		{
			return false;
		}

		if (this.m.Home != null && !this.m.Home.isNull() && _tile.ID == this.m.Home.getTile().ID)
		{
			return true;
		}

		if (this.m.Origin != null && !this.m.Origin.isNull() && _tile.ID == this.m.Origin.getTile().ID)
		{
			return true;
		}

		return this.onIsTileUsed(_tile);
	}

	function cancel()
	{
		this.World.Assets.addBusinessReputation(this.Const.World.Assets.ReputationOnContractCancel);

		if (this.m.Faction != 0)
		{
			this.World.FactionManager.getFaction(this.m.Faction).addPlayerRelation(this.Const.World.Assets.RelationContractCancel, "Broke a contract");

			if (this.m.Payment.Advance != 0)
			{
				this.World.FactionManager.getFaction(this.m.Faction).addPlayerRelation(this.Const.World.Assets.RelationContractCancelAdvance, "Broke a contract");
			}
		}

		this.onCancel();
	}

	function clear()
	{
		this.clearSpawnedUnits();
		this.onClear();
	}

	function updateSpawnedUnits()
	{
		foreach( i, id in this.m.UnitsSpawned )
		{
			local p = this.World.getEntityByID(id);

			if (p == null || !p.isAlive())
			{
				this.m.UnitsSpawned.remove(i);
				break;
			}
			else if (p.isDiscovered())
			{
				if (this.m.MakeAllSpawnsAttackableByAIOnceDiscovered)
				{
					p.setAttackableByAI(true);
				}

				if (this.m.MakeAllSpawnsResetOrdersOnceDiscovered)
				{
					p.getController().clearOrders();
				}
			}
		}
	}

	function clearSpawnedUnits()
	{
		foreach( id in this.m.UnitsSpawned )
		{
			local p = this.World.getEntityByID(id);

			if (p != null && p.isAlive())
			{
				p.setAttackableByAI(true);
				p.getSprite("selection").Visible = false;

				if (this.m.MakeAllSpawnsResetOrdersOnContractEnd)
				{
					p.getController().clearOrders();
					p.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setTarget(null);
				}
			}
		}

		this.m.UnitsSpawned = [];
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

	function onCancel()
	{
	}

	function onIsValid()
	{
		return true;
	}

	function onIsTileUsed( _tile )
	{
		return false;
	}

	function onHomeSet()
	{
	}

	function onOriginSet()
	{
	}

	function onActorKilled( _actor, _killer, _combatID )
	{
		if (this.m.ActiveState != null && "onActorKilled" in this.m.ActiveState)
		{
			this.m.ActiveState.onActorKilled(_actor, _killer, _combatID);
		}
	}

	function onActorRetreated( _actor, _combatID )
	{
		if (this.m.ActiveState != null && "onActorRetreated" in this.m.ActiveState)
		{
			this.m.ActiveState.onActorRetreated(_actor, _combatID);
		}
	}

	function onRetreatedFromCombat( _combatID )
	{
		if (this.m.ActiveState != null && "onRetreatedFromCombat" in this.m.ActiveState)
		{
			this.m.ActiveState.onRetreatedFromCombat(_combatID);
		}
	}

	function onCombatVictory( _combatID )
	{
		if (this.m.ActiveState != null && "onCombatVictory" in this.m.ActiveState)
		{
			this.m.ActiveState.onCombatVictory(_combatID);
		}
	}

	function onPartyDestroyed( _party )
	{
		if (this.m.ActiveState != null && "onPartyDestroyed" in this.m.ActiveState)
		{
			this.m.ActiveState.onPartyDestroyed(_party);
		}
	}

	function onLocationDestroyed( _location )
	{
		if (this.m.ActiveState != null && "onLocationDestroyed" in this.m.ActiveState)
		{
			this.m.ActiveState.onLocationDestroyed(_location);
		}
	}

	function getScaledDifficultyMult()
	{
		local s = this.Math.maxf(0.75, 0.94 * this.Math.pow(0.01 * this.World.State.getPlayer().getStrength(), 0.89));
		local d = this.Math.minf(5.0, s);
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function getReputationToPaymentMult()
	{
		local r = this.Math.minf(2.5999999, this.Math.maxf(1.35, this.Math.pow(this.Math.maxf(0, 0.003 * this.World.Assets.getBusinessReputation()), 0.39)));
		return r * this.Const.Difficulty.PaymentMult[this.World.Assets.getEconomicDifficulty()];
	}

	function getReputationToPaymentLightMult()
	{
		local r = this.Math.minf(1.9, this.Math.maxf(1.3, this.Math.pow(this.Math.maxf(0, 0.003 * this.World.Assets.getBusinessReputation()), 0.35)));
		return r * this.Const.Difficulty.PaymentMult[this.World.Assets.getEconomicDifficulty()];
	}

	function colorizeDone( _str )
	{
		return "[color=#30ac2a]" + _str + "[/color]";
	}

	function beautifyNumber( _n )
	{
		_n = this.Math.round(_n * 0.1);
		_n = _n * 10.0;
		return _n;
	}

	function isPlayerAt( _location )
	{
		return this.getVecDistance(_location.getPos(), this.World.State.getPlayer().getPos()) <= 150;
	}

	function isPlayerNear( _other, _distance )
	{
		return this.getVecDistance(_other.getPos(), this.World.State.getPlayer().getPos()) <= _distance;
	}

	function isEntityAt( _entity, _location )
	{
		return this.getVecDistance(_location.getPos(), _entity.getPos()) <= 175;
	}

	function isEnemyPartyNear( _entity, _distance )
	{
		local parties = this.World.getAllEntitiesAtPos(_entity.getPos(), _distance);

		foreach( party in parties )
		{
			if (party.isLocation())
			{
				continue;
			}

			if (!party.isAlliedWithPlayer() || !party.isAlliedWith(this.getFaction()))
			{
				return true;
			}
		}

		return false;
	}

	function getDaysRequiredToTravel( _numTiles, _speed, _onRoadOnly )
	{
		local speed = _speed * this.Const.World.MovementSettings.GlobalMult;

		if (_onRoadOnly)
		{
			speed = speed * this.Const.World.MovementSettings.RoadMult;
		}

		local seconds = _numTiles * 170.0 / speed;

		if (seconds / this.World.getTime().SecondsPerDay > 1.0)
		{
			seconds = seconds * 1.1;
		}

		return this.Math.max(1, this.Math.round(seconds / this.World.getTime().SecondsPerDay));
	}

	function getNearestLocationTo( _to, _list, _removeFromList = false )
	{
		local bestDist = 9000;
		local best;
		local bestIdx = 0;

		foreach( i, s in _list )
		{
			local d = _to.getTile().getDistanceTo(s.getTile());

			if (d < bestDist)
			{
				bestDist = d;
				best = s;
				bestIdx = i;
			}
		}

		if (_removeFromList && best != null)
		{
			_list.remove(bestIdx);
		}

		return best;
	}

	function getDistanceToNearestSettlement()
	{
		local bestDist = 9000;
		local myTile = this.World.State.getPlayer().getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			local d = myTile.getDistanceTo(s.getTile());

			if (d < bestDist)
			{
				bestDist = d;
			}
		}

		return bestDist;
	}

	function isEnemiesNearby()
	{
		local parties = this.World.getAllEntitiesAtPos(this.World.State.getPlayer().getPos(), 400.0);

		foreach( party in parties )
		{
			if (!party.isAlliedWithPlayer)
			{
				return true;
			}
		}

		return false;
	}

	function addUnitsToEntity( _entity, _partyList, _resources )
	{
		local total_weight = 0;
		local potential = [];

		foreach( party in _partyList )
		{
			if (party.Cost < _resources * 0.7)
			{
				continue;
			}

			if (party.Cost > _resources)
			{
				break;
			}

			potential.push(party);
			total_weight = total_weight + party.Cost;
		}

		local p;

		if (potential.len() == 0)
		{
			local best;
			local bestCost = 9000;

			foreach( party in _partyList )
			{
				if (this.Math.abs(_resources - party.Cost) <= bestCost)
				{
					best = party;
					bestCost = this.Math.abs(_resources - party.Cost);
				}
			}

			p = best;
		}
		else
		{
			local pick = this.Math.rand(1, total_weight);

			foreach( party in potential )
			{
				if (pick <= party.Cost)
				{
					p = party;
					break;
				}

				pick = pick - party.Cost;
			}
		}

		foreach( t in p.Troops )
		{
			local mb;

			if (this.getDifficultyMult() >= 1.15)
			{
				mb = 5;
			}
			else if (this.getDifficultyMult() >= 0.85)
			{
				mb = 0;
			}
			else
			{
				mb = -99;
			}

			for( local i = 0; i != t.Num; i = ++i )
			{
				this.Const.World.Common.addTroop(_entity, t, false, mb);
			}
		}

		if (_entity.isLocation())
		{
			_entity.resetDefenderSpawnDay();
		}

		_entity.updateStrength();
	}

	function getTileToSpawnLocation( _pivot, _minDist, _maxDist, _notOnTerrain = [], _allowRoad = true, _needsLandConnection = true, _needsLandConnectionToPlayer = false )
	{
		local mapSize = this.World.getMapSize();
		local tries = 0;
		local myTile = _pivot;
		local minDistToLocations = _minDist == 0 ? 0 : this.Math.min(4, _minDist - 1);
		local used = [];
		local pathDistanceMult = 2;

		while (1)
		{
			tries = ++tries;

			if (tries == 500)
			{
				_maxDist = _maxDist * 2;
				_minDist = _minDist / 2;
			}
			else if (_needsLandConnection && tries == 2000)
			{
				used = [];
				pathDistanceMult = 4;
			}

			local x = this.Math.rand(myTile.SquareCoords.X - _maxDist, myTile.SquareCoords.X + _maxDist);
			local y = this.Math.rand(myTile.SquareCoords.Y - _maxDist, myTile.SquareCoords.Y + _maxDist);

			if (x <= 3 || x >= mapSize.X - 3 || y <= 3 || y >= mapSize.Y - 3)
			{
				continue;
			}

			if (!this.World.isValidTileSquare(x, y))
			{
				continue;
			}

			local tile = this.World.getTileSquare(x, y);

			if (used.find(tile.ID) != null)
			{
				continue;
			}

			used.push(tile.ID);

			if (tile.Type == this.Const.World.TerrainType.Ocean)
			{
				continue;
			}

			if (tile.IsOccupied)
			{
				continue;
			}

			if (tile.HasRoad && !_allowRoad)
			{
				continue;
			}

			if (tile.getDistanceTo(myTile) < _minDist)
			{
				continue;
			}

			local abort = false;

			foreach( t in _notOnTerrain )
			{
				if (t == tile.Type)
				{
					abort = true;
					break;
				}
			}

			if (abort)
			{
				continue;
			}

			if (!_allowRoad)
			{
				local hasRoad = false;

				for( local j = 0; j != 6; j = ++j )
				{
					if (tile.hasNextTile(j) && tile.getNextTile(j).HasRoad)
					{
						hasRoad = true;
						break;
					}
				}

				if (hasRoad)
				{
					continue;
				}
			}

			local settlements = this.World.EntityManager.getSettlements();

			foreach( s in settlements )
			{
				local d = s.getTile().getDistanceTo(tile);

				if (d < this.Math.max(_minDist, 4))
				{
					abort = true;
					break;
				}
			}

			if (abort)
			{
				continue;
			}

			if (minDistToLocations > 0)
			{
				local locations = this.World.EntityManager.getLocations();

				foreach( v in locations )
				{
					local d = tile.getDistanceTo(v.getTile());

					if (d < minDistToLocations)
					{
						abort = true;
						break;
					}
				}

				if (abort)
				{
					continue;
				}
			}

			if (_needsLandConnection)
			{
				local navSettings = this.World.getNavigator().createSettings();
				navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
				local path = this.World.getNavigator().findPath(myTile, tile, navSettings, 0);

				if (path.isEmpty())
				{
					continue;
				}
				/*
				for( ; path.getSize() > _maxDist * pathDistanceMult;  )
				{
				}
				*/
			}

			if (_needsLandConnectionToPlayer)
			{
				local navSettings = this.World.getNavigator().createSettings();
				navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;
				local path = this.World.getNavigator().findPath(this.World.State.getPlayer().getTile(), tile, navSettings, 0);

				if (path.isEmpty())
				{
					continue;
				}
			}

			return tile;
		}

		return null;
	}

	function spawnEnemyPartyAtBase( _factionType, _resources )
	{
		local myTile = this.World.State.getPlayer().getTile();
		local enemyBase = this.World.FactionManager.getFactionOfType(_factionType).getNearestSettlement(myTile);
		local party;

		if (_factionType == this.Const.FactionType.Bandits)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Bandits).spawnEntity(enemyBase.getTile(), "Brigands", false, this.Const.World.Spawn.BanditRaiders, _resources);
			party.setDescription("Une bande de brigands rudes et coriaces en quête de nourriture.");
			party.setFootprintType(this.Const.World.FootprintsType.Brigands);
			party.getLoot().Money = this.Math.rand(50, 100);
			party.getLoot().ArmorParts = this.Math.rand(0, 10);
			party.getLoot().Medicine = this.Math.rand(0, 2);
			party.getLoot().Ammo = this.Math.rand(0, 20);
			local r = this.Math.rand(1, 6);

			if (r == 1)
			{
				party.addToInventory("supplies/bread_item");
			}
			else if (r == 2)
			{
				party.addToInventory("supplies/roots_and_berries_item");
			}
			else if (r == 3)
			{
				party.addToInventory("supplies/dried_fruits_item");
			}
			else if (r == 4)
			{
				party.addToInventory("supplies/ground_grains_item");
			}
			else if (r == 5)
			{
				party.addToInventory("supplies/pickled_mushrooms_item");
			}
		}
		else if (_factionType == this.Const.FactionType.Goblins)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).spawnEntity(enemyBase.getTile(), "Goblin Raiders", false, this.Const.World.Spawn.GoblinRaiders, _resources);
			party.setDescription("Une bande de gobelins espiègles, petits mais rusés et à ne pas sous-estimer.");
			party.setFootprintType(this.Const.World.FootprintsType.Goblins);
			party.getLoot().ArmorParts = this.Math.rand(0, 10);
			party.getLoot().Medicine = this.Math.rand(0, 2);
			party.getLoot().Ammo = this.Math.rand(0, 30);

			if (this.Math.rand(1, 100) <= 75)
			{
				local loot = [
					"supplies/strange_meat_item",
					"supplies/roots_and_berries_item",
					"supplies/pickled_mushrooms_item"
				];
				party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
			}

			if (this.Math.rand(1, 100) <= 33)
			{
				local loot = [
					"loot/goblin_carved_ivory_iconographs_item",
					"loot/goblin_minted_coins_item",
					"loot/goblin_rank_insignia_item"
				];
				party.addToInventory(loot[this.Math.rand(0, loot.len() - 1)]);
			}
		}
		else if (_factionType == this.Const.FactionType.Orcs)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).spawnEntity(enemyBase.getTile(), "Orc Marauders", false, this.Const.World.Spawn.OrcRaiders, _resources);
			party.setDescription("Une bande d'orcs menaçants, à la peau verte et imposant n'importe quel homme.");
			party.setFootprintType(this.Const.World.FootprintsType.Orcs);
			party.getLoot().ArmorParts = this.Math.rand(0, 25);
			party.getLoot().Ammo = this.Math.rand(0, 10);
			party.addToInventory("supplies/strange_meat_item");
		}
		else if (_factionType == this.Const.FactionType.Undead)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(enemyBase.getTile(), "Undead", false, this.Const.World.Spawn.UndeadArmy, _resources);
			party.setDescription("Une légion de morts-vivants, de retour pour réclamer aux vivants ce qui leur appartenait autrefois.");
			party.setFootprintType(this.Const.World.FootprintsType.Undead);
			party.getLoot().ArmorParts = this.Math.rand(0, 10);
			party.getLoot().Ammo = this.Math.rand(0, 5);
		}
		else if (_factionType == this.Const.FactionType.Zombies)
		{
			party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).spawnEntity(enemyBase.getTile(), "Undead", false, this.Const.World.Spawn.Necromancer, _resources);
			party.setDescription("Quelque chose ne va pas.");
			party.setFootprintType(this.Const.World.FootprintsType.Undead);
			party.getLoot().ArmorParts = this.Math.rand(0, 10);
			party.getLoot().Ammo = this.Math.rand(0, 5);
		}

		party.getSprite("banner").setBrush(enemyBase.getBanner());
		this.m.UnitsSpawned.push(party.getID());
		return party;
	}

	function importNobleIntro()
	{
		local relation = this.World.FactionManager.getFaction(this.m.Faction).getPlayerRelation();

		if (relation <= 35)
		{
			this.m.Screens.extend(this.Const.Contracts.IntroNobleHouseCold);
		}
		else if (relation > 70)
		{
			this.m.Screens.extend(this.Const.Contracts.IntroNobleHouseFriendly);
		}
		else
		{
			this.m.Screens.extend(this.Const.Contracts.IntroNobleHouseNeutral);
		}
	}

	function importSettlementIntro()
	{
		local relation = this.World.FactionManager.getFaction(this.m.Faction).getPlayerRelation();

		if (relation <= 35)
		{
			this.m.Screens.extend(this.Const.Contracts.IntroSettlementCold);
		}
		else if (relation > 70)
		{
			this.m.Screens.extend(this.Const.Contracts.IntroSettlementFriendly);
		}
		else
		{
			this.m.Screens.extend(this.Const.Contracts.IntroSettlementNeutral);
		}
	}

	function importScreens( _screens )
	{
		this.m.Screens.extend(_screens);
	}

	function getDistanceOnRoads( _start, _dest )
	{
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost;
		navSettings.RoadMult = 0.2;
		navSettings.RoadOnly = true;
		local path = this.World.getNavigator().findPath(_start, _dest, navSettings, 0);

		if (!path.isEmpty())
		{
			return path.getSize();
		}
		else
		{
			return _start.getDistanceTo(_dest);
		}
	}

	function resolveSituation( _situationInstance, _settlement, _list = null )
	{
		if (_situationInstance == 0 || _settlement == null || typeof _settlement == "instance" && _settlement.isNull())
		{
			return 0;
		}

		local s = _settlement.getSituationByInstance(_situationInstance);
		local ret = _situationInstance;

		if (s != null)
		{
			ret = _settlement.removeSituationByInstance(_situationInstance);
		}

		if (_list != null && s != null && !_settlement.hasSituation(s.getID()))
		{
			_list.push({
				id = 10,
				icon = s.getIcon(),
				text = s.getRemovedString(_settlement.getName())
			});
		}

		return ret;
	}

	function addSituation( _situation, _days, _settlement, _list = null )
	{
		if (_situation == null || _settlement == null || typeof _settlement == "instance" && _settlement.isNull())
		{
			return 0;
		}

		_situation.setValidForDays(_days);
		local ret = _settlement.addSituation(_situation);

		if (_list != null)
		{
			_list.push({
				id = 10,
				icon = _situation.getIcon(),
				text = _situation.getAddedString(_settlement.getName())
			});
		}

		return ret;
	}

	function onSerialize( _out )
	{
		_out.writeI32(this.m.ID);
		_out.writeString(this.m.Name);
		_out.writeU8(this.m.Faction);
		_out.writeU32(this.m.EmployerID);
		_out.writeI32(this.m.SituationID);
		_out.writeF32(this.m.TimeOut);
		_out.writeU32(0);

		if (this.m.Home != null && !this.m.Home.isNull())
		{
			_out.writeU32(this.m.Home.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		if (this.m.Origin != null && !this.m.Origin.isNull())
		{
			_out.writeU32(this.m.Origin.getID());
		}
		else
		{
			_out.writeU32(0);
		}

		_out.writeF32(this.m.DifficultyMult);
		_out.writeF32(this.m.PaymentMult);
		_out.writeBool(this.m.IsDifficultyHidden);
		_out.writeU8(this.m.BulletpointsObjectives.len());

		foreach( b in this.m.BulletpointsObjectives )
		{
			_out.writeString(b);
		}

		_out.writeU8(this.m.BulletpointsPayment.len());

		foreach( b in this.m.BulletpointsPayment )
		{
			_out.writeString(b);
		}

		_out.writeU8(this.m.UnitsSpawned.len());

		foreach( id in this.m.UnitsSpawned )
		{
			_out.writeU32(id);
		}

		_out.writeF32(this.m.Payment.Pool);
		_out.writeF32(this.m.Payment.Advance);
		_out.writeF32(this.m.Payment.Completion);
		_out.writeF32(this.m.Payment.Count);
		_out.writeI32(this.m.Payment.MaxCount);
		_out.writeBool(this.m.IsActive);
		_out.writeBool(this.m.IsStarted);
		_out.writeBool(this.m.IsNegotiated);
		this.m.Flags.onSerialize(_out);

		if (this.m.ActiveScreen != null)
		{
			_out.writeString(this.m.ActiveScreen.ID);
		}
		else
		{
			_out.writeString("");
		}

		if (this.m.ActiveState != null)
		{
			_out.writeString(this.m.ActiveState.ID);
		}
		else
		{
			_out.writeString("");
		}
	}

	function onDeserialize( _in )
	{
		this.m.ID = _in.readI32();
		this.m.Name = _in.readString();
		this.m.Faction = _in.readU8();
		this.m.EmployerID = _in.readU32();
		this.m.SituationID = _in.readI32();
		this.m.TimeOut = _in.readF32();
		_in.readU32();
		local home = _in.readU32();

		if (home != 0)
		{
			this.setHome(this.World.getEntityByID(home));
		}

		local origin = _in.readU32();

		if (origin != 0)
		{
			this.setOrigin(this.World.getEntityByID(origin));
		}

		this.m.DifficultyMult = _in.readF32();
		this.m.PaymentMult = _in.readF32();
		this.m.IsDifficultyHidden = _in.readBool();
		local bulletpoints = _in.readU8();

		for( local i = 0; i != bulletpoints; i = ++i )
		{
			this.m.BulletpointsObjectives.push(_in.readString());
		}

		bulletpoints = _in.readU8();

		for( local i = 0; i != bulletpoints; i = ++i )
		{
			this.m.BulletpointsPayment.push(_in.readString());
		}

		local numUnits = _in.readU8();

		for( local i = 0; i != numUnits; i = ++i )
		{
			this.m.UnitsSpawned.push(_in.readU32());
		}

		this.m.Payment.Pool = _in.readF32();
		this.m.Payment.Advance = _in.readF32();
		this.m.Payment.Completion = _in.readF32();
		this.m.Payment.Count = _in.readF32();
		this.m.Payment.MaxCount = _in.readI32();
		this.m.IsActive = _in.readBool();
		this.m.IsStarted = _in.readBool();
		this.m.IsNegotiated = _in.readBool();
		this.m.Flags.onDeserialize(_in, false);
		this.onImportIntro();
		local screen = _in.readString();
		local state = _in.readString();

		if (state != "" && (this.m.ActiveState == null || state != this.m.ActiveState.ID))
		{
			this.setState(state);
		}

		if (screen != "" && (this.m.ActiveScreen == null || screen != this.m.ActiveScreen.ID))
		{
			this.setScreen(screen);
		}
	}

};

