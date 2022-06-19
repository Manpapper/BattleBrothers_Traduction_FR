this.refugee_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.refugee";
		this.m.Name = "Réfugié";
		this.m.Icon = "ui/backgrounds/background_38.png";
		this.m.BackgroundDescription = "Les réfugiés sont habitués à des voyages long et épuisants, ils n\'ont donc pas la conviction de se battre pour leurs foyers.";
		this.m.GoodEnding = "Le réfugié %name% s\'est révélé être un combattant naturel, mais il a fini par se retirer de la compagnie %companyname%. On dit qu\'il est retourné chez lui et qu\'il utilise actuellement toutes ses couronnes pour rebâtir sa maison.";
		this.m.BadEnding = "La chute de la compagnie %companyname% étant écrite en toutes lettres sur le mur, %name% le réfugié s\'est résolu à fuir. Il a utilisé les maigres couronnes qui lui restaient pour acheter une paire de chaussures et est retourné dans sa maison détruite pour essayer de la reconstruire. Alors qu\'il rentrait chez lui, un sauvageon analphabète l\'a assassiné et a mangé les chaussures.";
		this.m.HiringCost = 40;
		this.m.DailyCost = 4;
		this.m.Excluded = [
			"trait.impatient",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.tough",
			"trait.strong",
			"trait.loyal",
			"trait.cocky",
			"trait.fat",
			"trait.bright",
			"trait.fearless",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.greedy",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Refugee",
			"the Survivor",
			"Runsfar",
			"the Derelict",
			"the Surbated"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
		return "{Les catastrophes sont bon marché. | La maladie, l\'ultime main invisible. | Gagner ou perdre une guerre, rien ne change.} %name% est originaire d\'un petit village qui {n\'est plus qu\'un souvenir oral, à une génération près d\'être oublié. | a été détruit, pour le dire de manière concise. | n\'est plus qu\'une simple note de bas de page, gaspillant peu l\'encre de l\'historien. | a subi la colère du monde.} Mais %name% est un survivant. {Il a fui le désastre avec seulement les vêtements qu\'il portait. | Sa maison a brûlée, il a sauvé ce qu\'il a pu et s\'est enfuit. | Après avoir trouvé sa famille morte, il a rassemblé ce qu\'il a pu et s\'est enfui. | Guerre, famine, maladie. C\'est un peu flou pour lui maintenant.} {%name% est simplement un homme soucieux de regarder devant lui plutôt que derrière. | %name% n\'apporte guère plus qu\'un sentiment de détermination à toute épreuve, mais c\'est quelque chose qui vaut la peine. | Une histoire terrible a marqué son corps et lui a fait perdre la vue, mais l\'homme est motivé pour ne plus jamais revivre ce passé. | Ce que la ville a essayé de faire de lui n\'a pas fonctionné, à en juger par les rumeurs que vous entendez, ça veut dire quelque chose. | L\'homme n\'est pas doué pour les arts martiaux, mais il est sacrément résolu à survivre. | La vocation qu\'il avait dans le passé est maintenant oubliée. Comme beaucoup d\'autres, il cherche un travail de mercenaire pour s\'en sortir dans ce monde de plus en plus violent. | Parmi les nombreux réfugiés que vous avez vus, cet homme a décidé d\'arrêter de courir et de commencer à se battre.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-8,
				-5
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				7,
				5
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
				1,
				0
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
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
	}

});

