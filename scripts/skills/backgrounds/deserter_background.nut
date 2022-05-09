this.deserter_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.deserter";
		this.m.Name = "Déserteur";
		this.m.Icon = "ui/backgrounds/background_07.png";
		this.m.BackgroundDescription = "Les déserteurs ont reçu une certaine formation militaire, mais ne sont généralement pas désireux de la mettre en pratique.";
		this.m.GoodEnding = "%name% le Déserteur continued fighting for the %companyname%, ever striving to redeem his name. Word has it that during a brutal fight with orcs, he dove headfirst into a crowd of greenskins, surfing across the top of their shocked heads. His heroism rallied the men to an incredible victory and he lives out his days getting toasted in every bar he enters.";
		this.m.BadEnding = "You heard %name% le Déserteur actually renewed his title and fled a battle the %companyname% had with some greenskins. Goblins caught him out in the woods and turned his head into a goblet for an orc warlord.";
		this.m.HiringCost = 85;
		this.m.DailyCost = 11;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.impatient",
			"trait.clubfooted",
			"trait.fearless",
			"trait.sure_footing",
			"trait.brave",
			"trait.loyal",
			"trait.deathwish",
			"trait.cocky",
			"trait.determined",
			"trait.fragile",
			"trait.optimist",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"le Déserteur",
			"le Traître",
			"le Coureur",
			"le chien",
			"le Ver"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = this.Math.rand(1, 2);
		this.m.IsCombatBackground = true;
		this.m.IsLowborn = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Sera toujours satisfait d\'être en réserve"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%name% qui était un simple soldat dans l\'armée d\'un seigneur, mais qui subissait perte après perte, | Autrefois gardien à la périphérie de %randomtown%, %name% a vu tous ses amis mourir à cause des bêtes qui s\'y cachent. Après tant de pertes | Lorsque deux seigneurs se sont disputés pour savoir qui était propriétaire d\'un étang local, %name% a été enrôlé pour aider à régler l\'affaire. N\'étant personne, il était clair que sa vie n\'avait que peu de valeur. Un massacre plus tard, | Alors qu\'il était employé dans l\'armée d\'un seigneur, une horrible maladie s\'est abattue sur %name% et ses camarades. Craignant sa colère, | Lors d\'une longue campagne militaire, %name% a estimé qu\'il y avait trop de marche et trop peu de butin à récolter. Alors} il {a planté ses armes dans le sol et est parti. | a attendu la nuit pour déserter. | a décidé avec plusieurs autres de se séparer en signe de protestation. | s\'est porté volontaire pour une patrouille et, à la première occasion, a abandonné sa carrière de soldat.} {Ce n\'est pas un secret que les déserteurs sont largement méprisés - et %name% garde la tête basse pour éviter le regard des autres. | La plupart des déserteurs passent le reste de leur vie à éviter la corde, et %name% n\'est pas différent. | En endossant le costume de monsieur tout le monde, %name% a, pour un temps, évité le châtiment des déserteurs. | Par chance, %name% s\'en est sorti jusqu\'à présent.} {Mais maintenant qu\'il est fauché et sans argent, il cherche à revenir vers son ancien métier. | Peut-être contraint par les hommes de loi qui se rapprochent, il se retrouve maintenant à rejoindre une autre force de combat. | Malheureusement, ce n\'est pas un homme intelligent. Manquant d\'imagination pour poursuivre une carrière plus sûre, %name% retourne une fois de plus au combat. | Se sentant coupable d\'avoir abandonné ses frères sur le terrain, il cherche maintenant à se racheter en combattant pour une autre équipe. Mais qui peut dire qu\'il ne fuira pas à nouveau ? | Avec un porte-monnaie vide après avoir bu au point d\'en perdre ses souvenirs, il considère maintenant toute opportunité de gagner sa vie.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-15,
				-10
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				5,
				5
			],
			RangedSkill = [
				7,
				0
			],
			MeleeDefense = [
				3,
				5
			],
			RangedDefense = [
				3,
				5
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/bludgeon"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/militia_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/hatchet"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/weapons/short_bow"));
			items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/padded_surcoat"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/gambeson"));
		}

		r = this.Math.rand(0, 5);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/open_leather_cap"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;
	}

});

