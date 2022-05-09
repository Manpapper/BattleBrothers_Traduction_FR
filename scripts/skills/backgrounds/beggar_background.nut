this.beggar_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.beggar";
		this.m.Name = "Mendiant";
		this.m.Icon = "ui/backgrounds/background_18.png";
		this.m.BackgroundDescription = "Les mendiants ne sont pas les personnes les plus déterminées, et vivre dans la rue à tendance à être préjudiciable à leur santé.";
		this.m.GoodEnding = "Having enough of all the fighting, %name% the once-beggar retired from the %companyname%. You know the man made a pretty crown in his time with the mercenary company, yet the other day you saw him out begging again. You asked if he\'d wasted all his money and he laughed. He said he\'d purchased land and was doing just fine. Then he held out his little tin and asked for a crown. You gave him two.";
		this.m.BadEnding = "The fighting life is a rough one, and %name% the once-beggar saw fit to retire from it before it became a deadly one. Unfortunately, he went back to beggaring. Word has it that a nobleman cleaned a city of riff-raff and sent them marching north despite it being winter. Cold and hungry, %name% died on the side of a road, a tin cup frozen to his finger.";
		this.m.HiringCost = 30;
		this.m.DailyCost = 3;
		this.m.Excluded = [
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.athletic"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Bravery
		];
		this.m.Titles = [
			"the Dirty",
			"the Poor",
			"the Ragged",
			"the Sick",
			"the Liar",
			"the Idle",
			"the Sloth",
			"the Useless",
			"the Beggar",
			"the Weasel",
			"the Skunk",
			"the Sluggard",
			"the Homeless"
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
		return "{Après avoir tout perdu dans un incendie, après que son addiction au jeu ait pris le dessus, après avoir été accusé d\'un crime qu\'il n\'a pas commis, et après avoir dû tout payer à l\'agent pour ne pas se retrouver dans les oubliettes, Un homme sans talent et sans ambition | Après avoir été libéré du donjon d\'un seigneur où il a passé d\'innombrables années enchaîné à un mur | Après avoir donné tous ses biens à une obscure secte promettant le salut de son âme éternelle | Un homme très intelligent jusqu\'à ce qu\'un brigand le frappe à la tête}, {%name% s\'est retrouvé à la rue, | %name% a été forcé à la rue,} {dû mendier son pain | dépendre de la bonne volonté des autres | être battu et résigné à son sort | dépenser le peu d\'argent qu\'il avait pour boire les jours durant | fouiller dans les poubelles des autres et fuir les hommes de loi | éviter les ruffians et les voyous pendant qu\'il mendiait des couronnes}. {Bien qu\'il semble sincèrement vouloir devenir mercenaire, il ne fait aucun doute que tout le temps passé dans la rue a privé %name% de ses meilleures années. | Les années ont passé et ont eu raison de sa santé à présent. | Une fois qu\'un homme comme %name% a passé quelques jours dans les rues, et encore moins quelques années, même le très dangereux métier de mercenaire semble être le plus vert des pâturages. | Seuls les dieux savent ce que %name% a fait pour survivre, mais c\'est un homme frêle qui se tient devant vous maintenant. | A votre vue, il se lève à bras ouverts pour vous embrasser, affirmant vous connaître depuis des années et de nombreuses aventures partagées, bien que votre nom lui échappe pour le moment.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-10
			],
			Bravery = [
				-10,
				-5
			],
			Stamina = [
				-10,
				-10
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
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/hood");
			item.setVariant(38);
			items.equip(item);
		}
	}

});

