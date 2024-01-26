this.militia_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.militia";
		this.m.Name = "Milice Paysanne";
		this.m.Description = "[p=c][img]gfx/ui/events/event_141.png[/img][/p][p]Ça a commencé avec une milice en guenille composée de courageux ou de personnes assez désespérées pour se proposer à défendre leurs maisons, mais qui a grossi pour devenir une petite armée. Une armée qui a besoin d\'être nourri tous les jours. Peut-être que les services de la milice pouraient être loués ?\n[color=#bcad8c]Armée Paysanne :[/color] Commencez avec une compagnie de 12 paysans très mal équipés.\n[color=#bcad8c]Vague Humaine[/color] : Emmenez jusqu\'à 16 hommes en bataille en même temps, et ayez jusqu\'à 25 hommes dans votre compagnie.\n[color=#bcad8c]Sales Paysans[/color] : Vous pouvez engager seulement des paysans de naissance.[/p]";
		this.m.Difficulty = 1;
		this.m.Order = 20;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 12; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.worsenMood(1.5, "Lost many a friend in battle");
			bro.improveMood(0.5, "Part of a militia");
			bro.m.HireTime = this.Time.getVirtualTimeF();

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		bros[0].setStartValuesEx([
			"farmhand_background"
		]);
		bros[0].getBackground().m.RawDescription = "%name% est le fils d'un fermier et souhaite probablement être le père de son propre fils à un moment donné. Pour l'instant, il est avec toi, ce qui constitue un regrettable conflit entre les rêves et la réalité.";
		bros[0].improveMood(3.0, "Has recently fallen in love");
		local items = bros[0].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/pitchfork"));
		bros[1].setStartValuesEx([
			"farmhand_background"
		]);
		bros[1].getBackground().m.RawDescription = "%name% possédait une ferme qui a depuis longtemps succombé aux innombrables armées passantes, y compris celles pour lesquelles il a combattu. Son 'allégeance' envers toi est sans doute le résultat d'un ventre vide plus que de tout autre chose.";
		bros[1].worsenMood(0.5, "Was involved in a brawl");
		bros[1].addLightInjury();
		local items = bros[1].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/warfork"));
		bros[2].setStartValuesEx([
			"poacher_background"
		]);
		bros[2].getBackground().m.RawDescription = "C'est une blague courante que %name% est en réalité un noble se cachant du monde, mais selon vos connaissances, il était simplement un braconnier. Le dur labeur du monde l'a amené là où il est aujourd'hui, il n'y a pas grand-chose d'autre à dire sinon que vous espérez qu'il se remettra sur pied.";
		bros[2].worsenMood(0.5, "Was involved in a brawl");
		bros[2].addLightInjury();
		local items = bros[2].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/staff_sling"));
		bros[3].setStartValuesEx([
			"vagabond_background",
			"thief_background",
			"gambler_background"
		]);
		bros[3].getBackground().m.RawDescription = "Tu remarques que %name% se cache de certains nobles. Il est probable qu'il soit un criminel commun en fuite pour quelque petit crime, mais tant qu'il se bat bien, cela ne te concerne pas.";
		bros[3].improveMood(1.5, "Stole someone\'s scramasax");
		items = bros[3].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/scramasax"));
		bros[4].setStartValuesEx([
			"daytaler_background"
		]);
		bros[4].getBackground().m.RawDescription = "Un jourtravailleur et ouvrier ordinaire, %name% préférerait rejoindre ta troupe que de retourner gaspiller son corps à construire le nouveau foyer fantaisiste d'un noble.";
		bros[4].addLightInjury();
		bros[5].setStartValuesEx([
			"miller_background"
		]);
		bros[5].getBackground().m.RawDescription = "À la recherche de richesse, %name% est venu au bon endroit dans ta nouvelle bande de mercenaires. Malheureusement, son passé se situe dans l'agriculture, la meunerie et la pose de pierre, domaines dans lesquels il n'était particulièrement doué.";
		bros[5].improveMood(1.0, "Looks forward to becoming rich as a sellsword");
		local items = bros[5].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/pitchfork"));
		bros[6].setStartValuesEx([
			"fisherman_background"
		]);
		bros[6].getBackground().m.RawDescription = "%name% déclare qu'il était marin avant de venir à l'intérieur des terres et de se joindre à la milice, puis à ta bande de mercenaires. Il espère éventuellement posséder un bateau et mettre ses voiles à l'océan ouvert. Tu espères qu'il pourra le faire un jour, vraiment.";
		bros[6].worsenMood(0.25, "Feels somewhat sickly of late");
		bros[7].setStartValuesEx([
			"militia_background"
		]);
		bros[7].getBackground().m.RawDescription = "%name% a apparemment été dans de nombreuses milices, toutes ayant finalement disparu pour une raison ou une autre. À aucun moment il n'a gagné d'argent dans aucune d'entre elles, alors il espère changer cela avec ce nouveau numéro de mercenariat.";
		bros[7].improveMood(3.0, "Has recently become a father");
		bros[7].m.PerkPoints = 0;
		bros[7].m.LevelUps = 0;
		bros[7].m.Level = 1;
		bros[8].setStartValuesEx([
			"minstrel_background"
		]);
		bros[8].getBackground().m.RawDescription = "Un vrai gars, %name% aime faire la fête avec les dames au pub et courir les jupons à l'église. Tu as l'impression qu'il n'est venu que pour répandre son sens du 'plaisir' dans le monde.";
		local items = bros[8].getItems();
		items.unequip(items.getItemAtSlot(this.Const.ItemSlot.Mainhand));
		items.equip(this.new("scripts/items/weapons/lute"));
		bros[9].setStartValuesEx([
			"daytaler_background"
		]);
		bros[9].getBackground().m.RawDescription = "Daytaler, ouvrier, homme de caravane, marin, milicien, %name% a tout fait un peu. Espérons que cette nouvelle incursion dans le travail de mercenaire lui convienne.";
		bros[9].worsenMood(1.0, "Had his trusty scramasax stolen");
		bros[10].setStartValuesEx([
			"militia_background"
		]);
		bros[10].getBackground().m.RawDescription ="Comme toi, %name% en avait assez que les milices soient trop souvent utilisées pour résoudre les crises de nobles mal préparés. Il était peut-être le plus sincère des hommes à rejoindre la transition vers le travail de mercenaire.";
		bros[10].worsenMood(0.5, "Disliked that some members of the militia were involved in a brawl");
		bros[10].m.PerkPoints = 0;
		bros[10].m.LevelUps = 0;
		bros[10].m.Level = 1;
		bros[11].setStartValuesEx([
			"butcher_background",
			"tailor_background",
			"shepherd_background"
		]);
		bros[11].getBackground().m.RawDescription = "%name% est, apparemment, en train de fuir sa femme. Tu l'as rencontrée une fois et approuves entièrement son plan d'évasion, et pas seulement parce que cela te procure un autre corps sur la ligne de front. Cette mégère est vraiment folle.";
		bros[11].improveMood(1.0, "Managed to get away from his wife");
		this.World.Assets.m.BusinessReputation = -100;
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
		this.World.Assets.m.Money = this.World.Assets.m.Money / 2;
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

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() == 1)
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		this.World.Flags.set("HomeVillage", randomVillage.getName());
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

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else if (tile.Type != this.Const.World.TerrainType.Plains && tile.Type != this.Const.World.TerrainType.Steppe && tile.Type != this.Const.World.TerrainType.Tundra && tile.Type != this.Const.World.TerrainType.Snow)
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

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.Assets.updateLook(8);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		randomVillage.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(40.0, "Considered local heroes for keeping the village safe");
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList([
				"music/retirement_01.ogg"
			], this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.militia_scenario_intro");
		}, null);
	}

	function onInit()
	{
		this.World.Assets.m.BrothersMax = 25;
		this.World.Assets.m.BrothersMaxInCombat = 16;
		this.World.Assets.m.BrothersScaleMax = 14;
	}

	function onUpdateHiringRoster( _roster )
	{
		local garbage = [];
		local bros = _roster.getAll();

		foreach( i, bro in bros )
		{
			if (!bro.getBackground().isLowborn())
			{
				garbage.push(bro);
			}
		}

		foreach( g in garbage )
		{
			_roster.remove(g);
		}
	}

});

