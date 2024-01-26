this.gladiators_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.gladiators";
		this.m.Name = "Gladiateurs";
		this.m.Description = "[p=c][img]gfx/ui/events/event_155.png[/img][/p][p]Vous vous êtes battu dans l\'arène pendant des années. Au début pour votre liberté, ensuite pour les couronnes, et enfin pour devenir immortel. Que pourrait avoir le destin en stock pour vous ?\n\n[color=#bcad8c]Gladiators :[/color] Commencez avec trois gladiateurs expérimentés possédant un bon équipement, mais une paie journalière très élevée.\n[color=#bcad8c]Légendes de l\'Arène :[/color] Chaque gladiateur a un trait unique en combat.\n[color=#bcad8c]Les Trois Glorieux :[/color] Vous ne pouvez avoir plus de 12 hommes dans votre compagnie, et si les trois gladiateurs du départ meurent, votre campagne se termine.[/p]";
		this.m.Difficulty = 3;
		this.m.Order = 100;
		this.m.IsFixedLook = true;
	}

	function isValid()
	{
		return this.Const.DLC.Desert;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();

		for( local i = 0; i < 3; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.setStartValuesEx([
				"gladiator_origin_background"
			]);
			bro.getSkills().removeByID("trait.survivor");
			bro.getSkills().removeByID("trait.greedy");
			bro.getSkills().removeByID("trait.loyal");
			bro.getSkills().removeByID("trait.disloyal");
			bro.getSkills().add(this.new("scripts/skills/traits/arena_fighter_trait"));
			bro.getFlags().set("ArenaFightsWon", 5);
			bro.getFlags().set("ArenaFights", 5);
			bro.setPlaceInFormation(3 + i);
			bro.getFlags().set("IsPlayerCharacter", true);
			bro.getSprite("miniboss").setBrush("bust_miniboss_gladiators");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.m.PerkPoints = 2;
			bro.m.LevelUps = 2;
			bro.m.Level = 3;
			bro.m.Talents = [];
			bro.m.Attributes = [];
		}

		local bros = roster.getAll();
		local a;
		local u;
		bros[0].setTitle("the Lion");
		bros[0].getSkills().add(this.new("scripts/skills/traits/glorious_resolve_trait"));
		bros[0].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[0].getTalents()[this.Const.Attributes.MeleeDefense] = 2;
		bros[0].getTalents()[this.Const.Attributes.Fatigue] = 2;
		bros[0].getTalents()[this.Const.Attributes.MeleeSkill] = 3;
		bros[0].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/light_gladiator_upgrade"));
		bros[0].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(13);
		bros[0].getItems().equip(a);
		bros[0].getItems().equip(this.new("scripts/items/weapons/scimitar"));
		bros[0].getItems().equip(this.new("scripts/items/tools/throwing_net"));
		bros[0].improveMood(0.75, "Eager to prove himself outside the arena");
		bros[1].setTitle("the Bear");
		bros[1].getSkills().add(this.new("scripts/skills/traits/glorious_endurance_trait"));
		bros[1].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[1].getTalents()[this.Const.Attributes.Hitpoints] = 3;
		bros[1].getTalents()[this.Const.Attributes.Fatigue] = 2;
		bros[1].getTalents()[this.Const.Attributes.Bravery] = 2;
		bros[1].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade"));
		bros[1].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(15);
		bros[1].getItems().equip(a);
		bros[1].getItems().equip(this.new("scripts/items/weapons/oriental/heavy_southern_mace"));
		bros[1].getItems().equip(this.new("scripts/items/shields/oriental/metal_round_shield"));
		bros[1].improveMood(0.75, "Eager to prove himself outside the arena");
		bros[2].setTitle("the Viper");
		bros[2].getSkills().add(this.new("scripts/skills/traits/glorious_quickness_trait"));
		bros[2].getTalents().resize(this.Const.Attributes.COUNT, 0);
		bros[2].getTalents()[this.Const.Attributes.MeleeDefense] = 2;
		bros[2].getTalents()[this.Const.Attributes.Initiative] = 3;
		bros[2].getTalents()[this.Const.Attributes.MeleeSkill] = 2;
		bros[2].fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
		a = this.new("scripts/items/armor/oriental/gladiator_harness");
		a.setUpgrade(this.new("scripts/items/armor_upgrades/light_gladiator_upgrade"));
		bros[2].getItems().equip(a);
		a = this.new("scripts/items/helmets/oriental/gladiator_helmet");
		a.setVariant(14);
		bros[2].getItems().equip(a);
		bros[2].getItems().equip(this.new("scripts/items/weapons/oriental/qatal_dagger"));
		bros[2].getItems().equip(this.new("scripts/items/tools/throwing_net"));
		bros[2].improveMood(0.75, "Eager to prove himself outside the arena");
		bros[0].getBackground().m.RawDescription = "{%fullname% pense que les muscles font la gloire. Faux. Capitaine, c'est moi, " + bros[2].getName() + ", qui commande les dames de ce royaume. N'ayez pas besoin de me demander comment. Regardez ! Regardez ça ! Regardez la taille de ça ! Ouais. C'est ce que je pensais. Imbéciles, entraînez-vous autant que vous voulez, vous ne pouvez pas avoir ça !}";
		bros[0].getBackground().buildDescription(true);
		bros[0].getBackground().buildDescription(true);
		bros[1].getBackground().m.RawDescription = "{%fullname% n'est pas le meilleur guerrier ici, soyons clairs. Capitaine, regardez mes muscles, n'est-ce pas moi, " + bros[0].getName() + ", qui commande la plus grande récompense de la vie : la peur de ses propres ennemis ! Regardez, si je me lave un peu et que je capture la lumière, les muscles brillent. Ne serait-ce pas que les cieux se trompaient d'en haut, quand toutes les femmes disent les trouver ici, particulièrement ici, sur mes pectoraux glorieux ?}";
		bros[1].getBackground().buildDescription(true);
		bros[2].getBackground().m.RawDescription = "{Pourquoi regardez-vous %fullname% ? Capitaine, c'est moi, " + bros[1].getName() + ", qui suis votre plus grand gladiateur. C'est moi qui ai balayé les jambes d'un Lindwurm et l'ai étranglé avec sa propre queue ! Que dites-vous, salauds ? Vous appelez ça un conte de grande envergure ? Pah ! C'est un lézard horizontal au mieux.}";
		bros[2].getBackground().buildDescription(true);
		this.World.Assets.m.BusinessReputation = 100;
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() - 9);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/dried_lamb_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/wine_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2 - (this.World.Assets.getEconomicDifficulty() == 0 ? 0 : 300);
		this.World.Assets.m.ArmorParts = this.World.Assets.m.ArmorParts / 2;
		this.World.Assets.m.Medicine = this.World.Assets.m.Medicine / 2;
		this.World.Assets.m.Ammo = 0;
	}

	function onSpawnPlayer()
	{
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isIsolatedFromRoads() && randomVillage.isSouthern() && randomVillage.hasBuilding("building.arena"))
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 1), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 1));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 1), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 1));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) == 0)
				{
				}
				else if (!tile.HasRoad)
				{
				}
				else
				{
					randomVillageTile = tile;
					break;
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(16);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/worldmap_11.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.gladiators_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 12;
	}

	function onCombatFinished()
	{
		local roster = this.World.getPlayerRoster().getAll();
		local gladiators = 0;

		foreach( bro in roster )
		{
			if (bro.getFlags().get("IsPlayerCharacter"))
			{
				gladiators = ++gladiators;
			}
		}

		if (gladiators == 2 && !this.World.Flags.get("GladiatorsOriginDeath2"))
		{
			this.World.Flags.set("GladiatorsOriginDeath2", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{%fullname% est sombre à propos de la perte d'un bon ami, mais il regarde vers l'avenir en sachant qu'il a toujours quelqu'un derrière lui. Derrière lui d'une manière fraternelle, c'est-à-dire. Et spirituellement. Fraternellement et spirituellement, uniquement.}";
					bro.getBackground().buildDescription(true);
				}
			}
		}
		else if (gladiators == 1 && !this.World.Flags.get("GladiatorsOriginDeath1"))
		{
			this.World.Flags.set("GladiatorsOriginDeath1", true);

			foreach( bro in roster )
			{
				if (bro.getFlags().get("IsPlayerCharacter"))
				{
					bro.getBackground().m.RawDescription = "{Tu devrais savoir quelque chose, capitaine. Je suis content que tu restes en dehors de la mêlée. Je n'ai pas ressenti cela depuis au moins dix ans. Et si tu me vois sur le point de tomber, reste bien où tu es, car je serai exactement là où je veux être.}";
					bro.getBackground().buildDescription(true);
				}
			}
		}

		return gladiators != 0;
	}

});

