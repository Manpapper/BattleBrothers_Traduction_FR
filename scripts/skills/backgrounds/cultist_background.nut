this.cultist_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.cultist";
		this.m.Name = "Cultiste";
		this.m.Icon = "ui/backgrounds/background_34.png";
		this.m.BackgroundDescription = "Les cultistes ont une détermination à propager leur culte qui n\'a d\'égal que celle de peu de personnes.";
		this.m.GoodEnding = "Le Cultiste, %name%, a quitté la compagnie avec une bande de convertis cagoulés. Vous ne savez pas ce qu\'il est devenu, mais de temps en temps, vous faites des rêves dans lesquels il apparaît. Il se tient souvent seul dans un grand vide et il y a toujours quelqu\'un, ou quelque chose, qui s\'attarde dans l\'au-delà noir. Chaque nuit, cette image se précise un peu plus, et chaque nuit, vous vous retrouvez à veiller de plus en plus tard pour ne pas rêver du tout.";
		this.m.BadEnding = "Vous avez entendu dire que %name%, le Cultiste, a quitté la compagnie à un moment donné et est parti répandre sa foi. On ne sait pas ce qu\'il est devenu, mais il y a eu une récente inquisition contre les croyances impies et des centaines d\'hommes en cape sombre avec des intentions encore plus sombres ont été brûlés sur le bûcher à travers le royaume";
		this.m.HiringCost = 50;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.night_blind",
			"trait.lucky",
			"trait.athletic",
			"trait.bright",
			"trait.drunkard",
			"trait.dastard",
			"trait.gluttonous",
			"trait.insecure",
			"trait.disloyal",
			"trait.hesitant",
			"trait.fat",
			"trait.bright",
			"trait.greedy",
			"trait.craven",
			"trait.fainthearted"
		];
		this.m.Titles = [
			"le Cultiste",
			"le Fou",
			"le Croyant",
			"l\'Occultiste",
			"l\'Adepte",
			"le Perdu",
			"l\'étrange",
			"l\'égaré",
			"le Fanatique",
			"le Zélote"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{L\'homme se tient debout avec une pancarte accrochée à son cou. | Le visage de l\'homme est couvert de tatouages voyants. Il porte une note. | L\'homme cache son visage à l\'intérieur d\'une profonde cagoule, un bout de nez est tout ce que l\'on voit dans l\'obscurité. Il porte une pancarte autour du cou. | Vêtu de haillons, il est étrange que cet homme ne transpire ni ne tremble dans la chaleur ou le froid. Il s\'accroche à un parchemin comme si celui-ci le protégeait des éléments. | Les textes sacrés sont écrits en cicatrices sur son bras, la codification de la folie. | L\'étranger écrit dans la poussière aussi rapidement qu\'un homme qui l\'a fait des milliers de fois. Son message est clair comme de l\'eau de roche. | L\'homme se tient debout avec un tome niché derrière un bras crochu. Il vous le tend. En l\'ouvrant, vous sentez le cuir comme vous ne l\'avez jamais touché auparavant. Il n\'y a qu\'un seul passage à l\'intérieur, écrit encore et encore.} On y lit: \"Ph\'nglui mglw\'nafh Davkul R\'lyeh wgah\'nagl fhtagn. Nn\'nilgh\'ri, nn\'nglui. Sgn\'wahl sll\'ha ep\'shogg.\" Hmm... pittoresque.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				5
			],
			Bravery = [
				15,
				10
			],
			Stamina = [
				3,
				3
			],
			MeleeSkill = [
				0,
				0
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
				0,
				0
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 50)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("tattoo_01_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			tattoo_head.setBrush("tattoo_01_head");
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
			tattoo_body.setBrush("tattoo_01_" + body.getBrush().Name);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/monk_robe"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/cultist_leather_robe"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/cultist_hood"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/cultist_leather_hood"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

