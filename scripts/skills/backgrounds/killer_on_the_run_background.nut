this.killer_on_the_run_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.killer_on_the_run";
		this.m.Name = "Tueur en cavale";
		this.m.Icon = "ui/backgrounds/background_02.png";
		this.m.BackgroundDescription = "Le tueur en cavale peut tuer à nouveau, et il sait où viser.";
		this.m.GoodEnding = "Toujours prêt à prendre des risques, vous avez accepté %name% dans les rangs de la compagnie %companyname% malgré le fait qu\'il soit un tueur en cavale. Cela a joué en votre faveur car il a prouvé qu\'il était un mercenaire compétent et courageux. Pour autant que vous le sachiez, il est toujours dans la société, profitant pleinement de chaque opportunité qu\'elle lui offre.";
		this.m.BadEnding = "Alors que beaucoup doutaient du risque d\'engager un tueur en cavale tel que %name%, l\'homme s\'est avéré être un mercenaire très compétent. Malheureusement, son ancienne vie l\'a rattrapé et des chasseurs de primes l\'ont enlevé dans la nuit. Vous pouvez trouver son squelette accroché à une potence à 15 mètres de hauteur.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.teamplayer",
			"trait.hate_undead",
			"trait.lucky",
			"trait.clubfooted",
			"trait.cocky",
			"trait.clumsy",
			"trait.loyal",
			"trait.hesitant",
			"trait.bright",
			"trait.brave",
			"trait.determined",
			"trait.deathwish",
			"trait.fainthearted",
			"trait.craven",
			"trait.fearless",
			"trait.optimist"
		];
		this.m.Titles = [
			"Darkhearted",
			"Backblade",
			"Throatslash",
			"on the Run",
			"the Wanted",
			"the Murderer"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Higher Chance To Hit Head"
			}
		];
	}

	function onBuildDescription()
	{
		return "{%fullname% a un visage que personne ne désire - un visage digne d\'un avis de recherche. | Avec du sang sur les mains, %name% ressemble à un homme qui vous a été décrit récemment par des chasseurs de primes. | %name% semble prêt à rejoindre n\'importe quel groupe - ou à disparaître dans ses rangs. | Lorsqu\'il rencontre des gens, %name% balbutie son nom comme s\'il était réticent à le donner.} {Reconnaître %name% n\'est pas difficile : cet homme est un meurtrier connu, Il a le sang de sa femme et de son amant sur les mains. | Derrière ses yeux sombres et changeants, se cache un crime mais aussi un sentiment d\'humanité, comme s\'il savait qu\'il avait fait du mal et cherchait à se racheter. | Ses jambes sont pleines de boue. Il a couru pendant longtemps. Ses mains tremblent car ses jambes courent à cause de ce que ses mains ont fait. | Ayant toujours voulu un fils, ils disent qu\'il a tué sa nouveau-née. | Certains pensent qu\'il a frappé un homme en état de légitime défense. | Alors qu\'on le fait chanter concernant des informations scandaleuses, il est difficile de le blâmer pour ce qu\'il a fait.} {Même s\'il a fait du mal, un groupe de tueurs pourrait utiliser un homme comme lui. Mais peut-on faire confiance à cet homme ?| Les yeux de %name% s\'éloignent des vôtres. Lorsque vous lui demandez comment il se débrouille avec une arme, il marmonne qu\'il n\'a eu à frapper \"l\'homme\" qu\'une seule fois. | Un homme du physique de %name% pourrait être utile, mais jusqu\'à quel point peut-on dépendre d\'un homme dont l\'ancienne vie était d\'être en cavale ? | L\'homme chanfreine ses ongles comme un castor le ferait avec un arbre. Il est nerveux, mais c\'est peut-être une bonne chose dans ce monde. | Les groupes de mercenaires sont exactement ce qu\'il faut pour un homme comme lui.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				4,
				0
			],
			RangedSkill = [
				2,
				3
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
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(1, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_tunic"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 10;
	}

});

