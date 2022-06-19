this.ratcatcher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.ratcatcher";
		this.m.Name = "Chasseur de rats";
		this.m.Icon = "ui/backgrounds/background_41.png";
		this.m.BackgroundDescription = "Les chasseur de rats doivent avoir des réflexes rapides pour attraper leurs proies.";
		this.m.GoodEnding = "%name%, le chasseur de rats, venait d\'horizons étranges, et il est retourné à des horizons encore plus étranges. Après avoir pris sa retraite de la compagnie %companyname%, il a créé une entreprise de chasse aux rats. Il faisait de bonnes affaires jusqu\'à ce qu\'on découvre qu\'il ne tuait pas les rats, mais qu\'il en stockait des milliers dans un entrepôt à l\'extérieur de la ville. Aux dernières nouvelles, l\'homme était plutôt satisfait de ses nouveaux et nombreux amis.";
		this.m.BadEnding = "Vous ne pensiez pas que %name% s\'intégrerait bien dans un groupe de mercenaires, mais il a prouvé qu\'il en était capable. Malheureusement, la compagnie %companyname% s\'est effondré et il est retourné a chasser ses rats. On vous a dit que son corps a été retrouvé dans un égout complètement couvert de rats grignoteurs. On dit qu\'il avait un sourire sur le visage.";
		this.m.HiringCost = 40;
		this.m.DailyCost = 4;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.clubfooted",
			"trait.brute",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.hesitant",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.sure_footing",
			"trait.clumsy",
			"trait.short_sighted"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
			}
		];
	}

	function onBuildDescription()
	{
		return "{Chasseur de rats, c\'est le titre que %name% préférait autrefois. | Avec une fierté peut-être mal placée, %name% se présente comme un homme des égouts. | Avec ses jambes arquées et sa maigreur, la carrière de chasseur de rats de %name% semble l\'avoir transformé.} Il a grandi dans %townname% et a survit {dans les ruelles | grâce aux rats, le fruit des égouts | aux côtés de choses velues et de rats}. {Pour se divertir, son père lui a appris à attraper de petits rongeurs | Le corps de son frère décédé a été mangé par des rats, créant un sentiment de vengeance envers les rongeurs | Sa mère exigeait les meilleures viandes qu\'il pouvait trouver, et elle ne voulait pas dire que ça devait, forcement, venir du marché}. Mais %townname% a une emprise sur les gens, et il a englouti %name% comme une créature géante et vorace. {Avoir entendu parler des plus grands rats du monde | Sentant qu\'il doit y avoir plus à faire que de chasser des rats dans la vie | Faisant confiance à sa capacité d\'entendre les rats parler entre eux}, %name% cherche maintenant à {utiliser son nez ratatiné, ses étranges habitudes de mastication, et ses mains rapides mais un peu dégoûtantes à meilleur escient. | écraser tous les rats, les voir crever devant lui, et entendre les cris de leurs proches. Il a le regard perdu et le poing serré quand il vous dit ça. | passer des rats aux chiens et peut-être aux humains, comme il le dit. Il n\'a pas l\'air de savoir dans quoi il s\'est embarqué, mais peut-être qu\'il vaut mieux ne pas lui dire. | servir de la soupe de rat, de la salade de rat, du kebab de rat, du pain de rat, du ragoût de rat, du poulet de rat, du vin de rat... au bout d\'un moment, vous arrêtez d\'écouter.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				0,
				0
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
				18,
				15
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.RatcatcherTitles[this.Math.rand(0, this.Const.Strings.RatcatcherTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/tools/throwing_net"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
	}

});

