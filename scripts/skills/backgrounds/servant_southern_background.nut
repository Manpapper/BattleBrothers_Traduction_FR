this.servant_southern_background <- this.inherit("scripts/skills/backgrounds/servant_background", {
	m = {},
	function create()
	{
		this.servant_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernThick;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
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
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{La vie est difficile. Plus pour certains que pour d\'autres. | Certains hommes peuvent tomber en disgrâce. D\'autres hommes n\'ont nulle part où tomber, étant déjà né dans la misère. | Si la vie est un coup de dés, certains sont peut-être fous d\'être des hommes plutôt que des souris.} %name% {était un serviteur d\'un seigneur décadent. | a servi une famille abusive où les enfants jouaient avec le feu. | a été kidnappé par des brigands et forcé de les servir tous. Jusqu\'au dernier. | a travaillé fébrilement pour des fous qui regardaient trop longtemps les étoiles.}  Il se trompait rarement sur sa place dans le monde. Un jour, cependant, ses maîtres {l\'ont battu jusqu\'à ce qu\'il perde connaissance. Lorsqu\'il se réveille, c\'est dans le lit d\'un médecin bienveillant qui refuse de le rendre à ses \"employeurs\". Au lieu de cela, %name% était libre de partir et ses maîtres ont été informés qu\'il était mort. | l\'ont libéré, sans poser de questions. Ne perdant pas de temps avec les formalités, %name% est parti pour de bon. | l\'ont invité à une fête. Croyant être un invité, il se présenta dans sa plus belle tenue - une chemise aux manches ourlées et un pantalon flottant qui cachait bien sa charpente squelettique. Malheureusement, c\'était lui le spectacle - ils lui ont donné un bouclier et une épée en bois, l\'ont jeté dans une arène avec un sanglier sauvage, et ont pris des paris en regardant l\'horrible spectacle. Il a échappé de justesse aux \"festivités\".} {%name% a depuis juré de ne plus jamais \"servir\" quelqu\'un. | L\'homme, bien que maintenant libéré de ses obligations, porte encore beaucoup d\'humiliation et de douleur de sa longue et dure vie.}";
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
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}
	}

});

