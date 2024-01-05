this.manhunters_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.manhunters";
		this.m.Name = "Chasseur d\'Hommes";
		this.m.Description = "[p=c][img]gfx/ui/events/event_172.png[/img][/p][p]Un conflit constant entre les villes état et les nomades permet de faire de bonnes affaires. La majorité de vos hommes sont des prisonniers, forcés à se battre pour gagner leur liberté, et leur rang s\'agrandit après chaque bataille.\n\n[color=#bcad8c]Armée de Prisonniers :[/color] Commencez avec deux chasseurs d\'homme et quatre endettés. Vous pouvez emmener jusqu\'à 16 hommes en combat. Avoir autant ou moins d\'endetté que de non-endetté rendra vos hommes insatisfaits.\n[color=#bcad8c]Superviseurs :[/color] Tous les non-endettés peuvent fouetter les endettés en combat pour réinitialiser leur morale et améliorer leurs stats.\n[color=#bcad8c]Prisonniers :[/color] Les prisonniers gagne 10% d\'experience en moins, sont bloqués au niveau 7 et mourront s\'ils sont abattu.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 89;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 6; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
		}

		local bros = roster.getAll();
		local talents;
		bros[0].setStartValuesEx([
			"manhunter_background"
		]);
		bros[0].setTitle("the Stoic");
		bros[0].getBackground().m.RawDescription = "{Dans un sens, tu n'as pas particulièrement d'affection pour %name%. Il n'est ni haineux ni clément envers les prisonniers de guerre, les criminels, et autres. Il gère simplement ses affaires. Mais il a aussi cette manière calme et inébranlable avec toi, et c'est un peu dérangeant. Cet homme a tellement de potentiel, c'est pourquoi tu l'as à bord pour la %companyname%, mais tu souhaiterais simplement qu'il montre de temps en temps un peu de passion.}";
		bros[0].setPlaceInFormation(12);
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/weapons/oriental/light_southern_mace"));
		bros[0].getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
		bros[0].m.Talents = [];
		talents = bros[0].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.Bravery] = 2;
		talents[this.Const.Attributes.RangedDefense] = 1;
		local traits = bros[0].getSkills().getAllSkillsOfType(this.Const.SkillType.Trait);

		foreach( t in traits )
		{
			if (!t.isType(this.Const.SkillType.Special) && !t.isType(this.Const.SkillType.Background))
			{
				bros[0].getSkills().remove(t);
			}
		}

		bros[1].setStartValuesEx([
			"manhunter_background"
		]);
		bros[1].setTitle("the Whip");
		bros[1].getBackground().m.RawDescription = "{%name% est l'une des pires personnes que vous ayez jamais connues. Il est impitoyablement brutal envers les endettés, même selon vos critères, et est responsable de la mort de quelques-uns de vos prises. Cela dit, sa cruauté servira bien à la compagnie. Et étant donné que vous l'avez déjà fouetté une fois ou deux pour avoir perdu des stocks, vous savez qu'il peut encaisser aussi bien qu'il peut donner.}";
		bros[1].setPlaceInFormation(13);
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Offhand));
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Head));
		items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		items.equip(this.new("scripts/items/weapons/battle_whip"));
		bros[1].getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
		bros[1].worsenMood(0.0, "Annoyed by your recent reprimand not to mistreat your captives");
		bros[1].m.Talents = [];
		talents = bros[1].getTalents();
		talents.resize(this.Const.Attributes.COUNT, 0);
		talents[this.Const.Attributes.Fatigue] = 2;
		talents[this.Const.Attributes.MeleeSkill] = 1;
		talents[this.Const.Attributes.Hitpoints] = 1;
		bros[2].setStartValuesEx([
			"slave_southern_background"
		]);
		bros[2].setTitle("the Learned");
		bros[2].getBackground().m.RawDescription = "{Vous avez trouvé %name% en train d'être emprisonné par les gardes de la ville. On aurait dit qu'ils allaient jouer à 'attrape le cimeterre' avec ses poignets jusqu'à ce que vous interveniez, soutenant qu'il devait de l'argent au Gilder bien avant de devoir de l'argent à un homme. Vous espériez le céder à des vizirs bien payés, mais aucun ne voulait le prendre, car il était trop 'instruit' et semblait être le genre de menace susceptible de provoquer une révolte. Contrairement à un homme de son rang, il vous témoigne un certain respect.}";
		bros[2].setPlaceInFormation(2);
		bros[2].getSkills().removeByID("trait.dumb");
		bros[2].getSkills().add(this.new("scripts/skills/traits/bright_trait"));
		bros[2].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/wooden_stick"));
		items.equip(this.new("scripts/items/helmets/oriental/nomad_head_wrap"));
		bros[2].worsenMood(0.0, "Misses his books");
		bros[3].setStartValuesEx([
			"slave_background"
		]);
		bros[3].setTitle("the Northerner");
		bros[3].getBackground().m.RawDescription = "{Ce n'est pas un homme sympathique, mais c'est à cela que servent les chaînes. %name% était sur le billot pour une série de crimes quand vous êtes tombé sur lui. Vous avez payé pour sa vie comme un investissement, déclarant qu'il devait maintenant travailler dur pour trouver le salut aux yeux du Gilder. Il n'est pas si sûr de vos convictions sincères, mais vous avez payé un prêtre pour confirmer que l'homme doit effectivement sa sueur à une sublimité supérieure.}";
		bros[3].setPlaceInFormation(3);
		bros[3].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[3].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/bludgeon"));
		bros[3].worsenMood(2.0, "Almost got executed");
		bros[3].improveMood(2.0, "Relieved that he escaped execution");
		bros[3].worsenMood(0.0, "Worried about what awaits him next");
		bros[4].setStartValuesEx([
			"slave_southern_background"
		]);
		bros[4].setTitle("the Deserter");
		bros[4].getBackground().m.RawDescription = "{%name% est un héritage de l'hérésie, un homme offert à vous par l'un des prêtres du Vizir. L'homme était un déserteur dans l'armée du grand seigneur, mais grâce à des connexions riches, il a réussi à éviter l'exécution. Cependant, il n'y a qu'une seule façon d'éviter le feu des enfers, et c'est à travers une gratitude endettée. Il travaillera pour vous jusqu'à ce qu'il trouve le salut, et quand cela arrivera dépend entièrement de vous.}";
		bros[4].setPlaceInFormation(4);
		bros[4].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[4].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/militia_spear"));
		bros[4].worsenMood(0.5, "Feels cursed to have deserted one army only to end up an indebted in another");
		bros[5].setStartValuesEx([
			"slave_southern_background"
		]);
		bros[5].setTitle("the Beggar");
		bros[5].getBackground().m.RawDescription ="{Trouvé dans les rues, %name% n'avait jamais eu beaucoup de chances. En tant que mendiant, il était physiquement facile de lui mettre les chaînes, et socialement personne ne s'en soucierait. Le Gilder ne se soucie pas de ceux qui ne travaillent pas, et chaque jour l'homme gaspillé sans mettre sa sueur en banque accumulait une dette. Maintenant, elle doit être payée, sinon il goûtera à ce feu désertique pour l'éternité. Il a en fait l'air plus en bonne santé maintenant que quand vous l'avez trouvé, bien qu'il ne semble jamais vous remercier pour cela.}";
		bros[5].setPlaceInFormation(5);
		bros[5].getSprite("miniboss").setBrush("bust_miniboss_indebted");
		local items = bros[5].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/wooden_stick"));
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/rice_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/misc/manhunters_ledger_item"));
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
		this.World.Assets.m.Money = this.World.Assets.m.Money;
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = this.World.Assets.m.Ammo / 2;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);
		
		this.countIndebted();
		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(18);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.manhunters_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 16;
		this.World.Assets.m.BrothersScaleMax = 14;
	}

	function onHired( _bro )
	{
		if (_bro.getBackground().getID() != "background.slave")
		{
			_bro.getSkills().add(this.new("scripts/skills/actives/whip_slave_skill"));
		}
		else
		{
			_bro.getSprite("miniboss").setBrush("bust_miniboss_indebted");
		}

		this.countIndebted();
	}

	function onCombatFinished()
	{
		this.countIndebted();
		return true;
	}

	function onUnlockPerk( _bro, _perkID )
	{
		if (_bro.getLevel() == 7 && _bro.getBackground().getID() == "background.slave" && _perkID == "perk.student")
		{
			_bro.setPerkPoints(_bro.getPerkPoints() + 1);
		}
	}

	function onUpdateLevel( _bro )
	{
		if (_bro.getLevel() == 7 && _bro.getBackground().getID() == "background.slave" && _bro.getSkills().hasSkill("perk.student"))
		{
			_bro.setPerkPoints(_bro.getPerkPoints() + 1);
		}
	}

	function onGetBackgroundTooltip( _background, _tooltip )
	{
		if (_background.getID() != "background.slave")
		{
			if (_background.getID() == "background.wildman")
			{
				_tooltip.pop();
				_tooltip.push({
					id = 16,
					type = "text",
					icon = "ui/icons/xp_received.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] de Gain d\'experience"
				});
			}
			else if (_background.getID() == "background.apprentice")
			{
				_tooltip.pop();
			}
			else if (_background.getID() == "background.historian")
			{
				_tooltip.pop();
				_tooltip.push({
					id = 16,
					type = "text",
					icon = "ui/icons/xp_received.png",
					text = "[color=" + this.Const.UI.Color.PositiveValue + "]+5%[/color] de Gain d\'experience"
				});
			}
			else
			{
				_tooltip.push({
					id = 16,
					type = "text",
					icon = "ui/icons/xp_received.png",
					text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] de Gain d\'experience"
				});
			}
		}
		else
		{
			_tooltip.push({
				id = 16,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+10%[/color] de Gain d\'experience"
			});
			_tooltip.push({
				id = 17,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "Limité aux personnages en dessous du niveau 7"
			});
			_tooltip.push({
				id = 18,
				type = "text",
				icon = "ui/icons/days_wounded.png",
				text = "Est définitivement mort s\'il est abattu et ne survivra pas à une blessure permanente."
			});
		}
	}

	function countIndebted()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local indebted = 0;
		local nonIndebted = [];

		foreach( bro in roster )
		{
			if (bro.getBackground().getID() == "background.slave")
			{
				indebted++;
			}
			else
			{
				nonIndebted.push(bro);
			}
		}

		this.World.Statistics.getFlags().set("ManhunterIndebted", indebted);
		this.World.Statistics.getFlags().set("ManhunterNonIndebted", nonIndebted.len());
	}

});

