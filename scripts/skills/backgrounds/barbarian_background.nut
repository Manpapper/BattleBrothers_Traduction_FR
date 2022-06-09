this.barbarian_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {
		Tattoo = 0
	},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.barbarian";
		this.m.Name = "Barbare";
		this.m.Icon = "ui/backgrounds/background_58.png";
		this.m.BackgroundDescription = "Barbare a besoin de description";
		this.m.GoodEnding = "%name% le barbare a pris tout l\'argent qu\'il a gagné avec la compagnie et s\'est aventuré au nord. Avec son argent, il a rassemblé une bande de guerriers et conquis tant de tribus qu\'aux dernières nouvelles, il avait été nommé \'Roi du nord\'.";
		this.m.BadEnding = "Les choses étant ce qu\'elles étaient, %name% est parti. Aux dernières nouvelles, il voyageait vers le nord. Sans le sou, avec pour seul bagage une hache, sans ressembler aux indigènes et sans parler leur langue, le barbare n\'est pas allé bien loin. Comme vous avez déjà vu ce qui est arrivé à ses semblables, il a soit déjà été tué, soit capturé comme esclave.";
		this.m.HiringCost = 200;
		this.m.DailyCost = 20;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_undead",
			"trait.night_blind",
			"trait.ailing",
			"trait.asthmatic",
			"trait.clubfooted",
			"trait.hesitant",
			"trait.loyal",
			"trait.tiny",
			"trait.fragile",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.insecure"
		];
		this.m.Titles = this.Const.Strings.BarbarianTitles;
		this.m.Faces = this.Const.Faces.WildMale;
		this.m.Hairs = this.Const.Hair.WildMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.WildExtended;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 4);
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

	function onBuildDescription()
	{
		return "{%name% a survécu à la bataille entre vous et sa propre tribu de guerriers. Il s\'est offert à votre compagnie ou à votre épée. Impressionné par sa bravoure, vous avez choisi de l\'accueillir. Une brute étrangère, il parle à peine votre langue maternelle et il n\'est pas apprécié par le reste de la compagnie. Mais si quelque chose peut lier deux hommes, c\'est de se battre l\'un contre l\'autre, de tuer quand il le faut et de boire toute la nuit à la taverne.}";
	}

	function onAdded()
	{
		if (this.m.IsNew)
		{
			this.getContainer().getActor().setName(this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)]);
		}

		this.character_background.onAdded();
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoos = [
			3,
			4,
			5,
			6
		];

		if (this.Math.rand(1, 100) <= 66)
		{
			this.m.Tattoo = tattoos[this.Math.rand(0, tattoos.len() - 1)];
			local tattoo_body = actor.getSprite("tattoo_body");
			local body = actor.getSprite("body");
			tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 66)
		{
			local tattoo_head = actor.getSprite("tattoo_head");
			tattoo_head.setBrush("tattoo_0" + tattoos[this.Math.rand(0, tattoos.len() - 1)] + "_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("tattoo_0" + this.m.Tattoo + "_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				5
			],
			Bravery = [
				10,
				5
			],
			Stamina = [
				10,
				5
			],
			MeleeSkill = [
				10,
				5
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				5,
				10
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(1, 3);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/barbarians/axehammer"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/barbarians/crude_axe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/barbarians/blunt_cleaver"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/barbarians/thick_furs_armor"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/barbarians/reinforced_animal_hide_armor"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/barbarians/hide_and_bone_armor"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/barbarians/scrap_metal_armor"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/barbarians/bear_headpiece"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/barbarians/leather_headband"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/barbarians/leather_helmet"));
		}
	}

	function onSerialize( _out )
	{
		this.character_background.onSerialize(_out);
		_out.writeU8(this.m.Tattoo);
	}

	function onDeserialize( _in )
	{
		this.character_background.onDeserialize(_in);
		this.m.Tattoo = _in.readU8();
	}

});

