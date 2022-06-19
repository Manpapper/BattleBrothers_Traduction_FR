this.servant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.servant";
		this.m.Name = "Serviteur";
		this.m.Icon = "ui/backgrounds/background_16.png";
		this.m.BackgroundDescription = "Les serviteurs ne sont souvent pas habitués à un travail physique exigeant.";
		this.m.GoodEnding = "Il s\'avère que %name%, le serviteur, avait caché toutes les couronnes qu\'il avait gagnées au sein de la compagnie %companyname%. Quand il en a eu assez, il a pris sa retraite, s\'est acheté des terres et a lentement gravi les échelons de la société. Il est mort dans un lit confortable, entouré de ses amis, de sa famille et de ses fidèles serviteurs.";
		this.m.BadEnding = "%name% le serviteur s\'est lassé de la vie de mercenaire et a quitté la compagnie. Il est retourné servir la noblesse. Lorsque des pillards ont attaqué le château de son seigneur, le noble a poussé le serviteur hors des murs avec seulement un couteau de cuisine pour se défendre. Il fut retrouvé sans tête au milieu de chaises cassées, quelques pillards morts éparpillés autour de lui.";
		this.m.HiringCost = 45;
		this.m.DailyCost = 4;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.hate_greenskins",
			"trait.hate_beasts",
			"trait.impatient",
			"trait.iron_jaw",
			"trait.brute",
			"trait.athletic",
			"trait.strong",
			"trait.disloyal",
			"trait.fat",
			"trait.brave",
			"trait.fearless",
			"trait.optimist",
			"trait.cocky",
			"trait.bright",
			"trait.determined",
			"trait.greedy",
			"trait.sure_footing",
			"trait.bloodthirsty"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
	}

	function onBuildDescription()
	{
		return "{La vie est difficile. Plus pour certains que pour d\'autres. | Certains hommes peuvent tomber en disgrâce. D\'autres hommes n\'ont nulle part où tomber, étant déjà né dans la misère. | Si la vie est un coup de dés, certains sont peut-être fous d\'être des hommes plutôt que des souris.} %name% {était un serviteur d\'un seigneur décadent. | a servi une famille abusive où les enfants jouaient avec le feu. | a été kidnappé par des brigands et forcé de les servir tous. Jusqu\'au dernier. | a travaillé fébrilement pour des fous qui regardaient trop longtemps les étoiles.}  Il se trompait rarement sur sa place dans le monde. Un jour, cependant, ses maîtres {l\'ont battu jusqu\'à ce qu\'il perde connaissance. Lorsqu\'il se réveille, c\'est dans le lit d\'un médecin bienveillant qui refuse de le rendre à ses \"employeurs\". Au lieu de cela, %name% était libre de partir et ses maîtres ont été informés qu\'il était mort. | l\'ont libéré, sans poser de questions. Ne perdant pas de temps avec les formalités, %name% est parti pour de bon. | l\'ont invité à une fête. Croyant être un invité, il se présenta dans sa plus belle tenue - une chemise aux manches ourlées et un pantalon flottant qui cachait bien sa charpente squelettique. Malheureusement, c\'était lui le spectacle - ils lui ont donné un bouclier et une épée en bois, l\'ont jeté dans une arène avec un sanglier sauvage, et ont pris des paris en regardant l\'horrible spectacle. Il a échappé de justesse aux \"festivités\".} {%name% a depuis juré de ne plus jamais \"servir\" quelqu\'un. | L\'homme, bien que maintenant libéré de ses obligations, porte encore beaucoup d\'humiliation et de douleur de sa longue et dure vie.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-5
			],
			Bravery = [
				-5,
				-5
			],
			Stamina = [
				-5,
				-5
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
				2,
				0
			],
			Initiative = [
				5,
				0
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
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}
	}

});

