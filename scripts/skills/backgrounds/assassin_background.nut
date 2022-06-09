this.assassin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.assassin";
		this.m.Name = "Assassin";
		this.m.Icon = "ui/backgrounds/background_53.png";
		this.m.BackgroundDescription = "Le crédo des assassin est par nature de passer incognito";
		this.m.GoodEnding = "%name% a rejoint la compagnie à la place du noble bâtard qu\'il était venu tuer. C\'était si étrange, que vous avez gardé un oeil sur l\'assassin pendant plusieurs jours. Mais tout ce qu\'il a fait, c\'est se battre pour la compagnie %companyname%, et de bien le faire. Aux dernières nouvelles, l\'assassin a quitté la compagnie et n\'a pas été vu ou entendu depuis. Vous avez vérifié auprès du noble bâtard lui-même pour voir si l\'assassin n\'avait pas fini le travail, mais l\'homme était vivant et bien portant. Une drôle de rencontre, en fin de compte.";
		this.m.BadEnding = "%name% a rejoint la compagnie à la place du noble bâtard qu\'il était venu tuer. C\'était si étrange, que vous avez gardé un oeil sur l\'assassin pendant plusieurs jours. Mais tout ce qu\'il a fait, c\'est se battre pour la compagnie %companyname%, et de bien le faire. Aux dernières nouvelles, l\'assassin a quitté la compagnie peu de temps après votre retraite précipitée. Vous avez décidé d\'aller voir sa cible, le noble bâtard, pour découvrir qu\'il avait été tué par un assassin invisible. Il semble que %name% ait fini le travail à la fin.";
		this.m.HiringCost = 800;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.teamplayer",
			"trait.night_blind",
			"trait.clubfooted",
			"trait.dumb",
			"trait.loyal",
			"trait.clumsy",
			"trait.fat",
			"trait.strong",
			"trait.hesitant",
			"trait.insecure",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.brute",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Fatigue,
			this.Const.Attributes.RangedDefense,
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"the Assassin"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.Level = 4;
		this.m.IsCombatBackground = true;
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
			}
		];
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				10,
				10
			],
			Stamina = [
				-5,
				-5
			],
			MeleeSkill = [
				12,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				20,
				15
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
		actor.setTitle("the Assassin");
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		items.equip(this.new("scripts/items/weapons/rondel_dagger"));
		items.equip(this.new("scripts/items/armor/thick_dark_tunic"));
		items.equip(this.new("scripts/items/helmets/hood"));
	}

});

