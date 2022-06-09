this.butcher_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.butcher";
		this.m.Name = "Boucher";
		this.m.Icon = "ui/backgrounds/background_43.png";
		this.m.BackgroundDescription = "Les bouchers ont l\'habitude de faire couler le sang...";
		this.m.GoodEnding = "Le travail de mercenaire est une activité sanglante, c\'est probablement pour cela qu\'un boucher comme %name% s\'y sentait à l\'aise. Bien qu\'il soit un combattant hors pair, vous entendez dire qu\'il a toujours des problèmes avec les chiens de guerre dans le groupe et qu\'il a été surpris à plusieurs reprises en train d\'essayer de les massacrer. Finalement, si ce n\'est désespérément, la société a donné à l\'homme un adorable chiot à élever comme le sien. D\'après ce que vous savez, les yeux de biche brillants du petit avorton ont converti le chien qu\'il détestait en un amant. Maintenant, il a une soif de sang insatiable dès qu'un chien de garde est blessé et son petit bâtard est devenu la bête la plus féroce de la compagnie!";
		this.m.BadEnding = "%name% le boucher a fini par quitter la compagnie en déclin. Il a rejoint une autre équipe, mais a été surpris en train d\'abattre un de leurs chiens de guerre. Apparemment, il a nourri les mercenaires avec de la viande de chien provenant de tous les bâtards qui ont \'disparu\'. Ils n\'ont pas apprécié cette nouvelle, ont dépouillé le boucher et l\'ont donné en pâture aux bêtes.";
		this.m.HiringCost = 80;
		this.m.DailyCost = 7;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.swift",
			"trait.bleeder",
			"trait.bright",
			"trait.clumsy",
			"trait.fainthearted",
			"trait.spartan",
			"trait.iron_lungs",
			"trait.tiny",
			"trait.optimist"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"the Butcher",
			"the Cleaver",
			"the Red",
			"Redmeat",
			"Bloodeye"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Thick;
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
		return "{Après la mort de son père, %name% a repris la boucherie familiale dans %randomtown%. | Ayant grandi dans la pauvreté, %name% a rapidement appris à tuer et à dépouiller les animaux, pour finalement fonder une boucherie. | Avec les sécheresses qui ont ruiné les terres agricoles, la boucherie de %name% s\'est développée dans %randomtown%. | Toujours un garçon étrange, %name% s\'est mis à la boucherie non seulement pour le profit, mais aussi pour le plaisir. | En souriant jusqu\'aux oreilles, %name% n\'a jamais eu l\'air aussi heureux que lorsque sa boutique a ouvert et qu\'il a reçu sa première commande de porcs vivants en stock. | En tant que boucher, %name% a passé des années à vider les boyaux de lapins morts et à décapiter des poissons parfois morts.} {Mais les rumeurs de torture animale ont fini par pousser le boucher à abandonner son commerce. | Vu les terribles rumeurs de magie noire qui circulaient déjà, il n\'a pas fallu longtemps pour que les gens commencent à s\'interroger sur la provenance de ses viandes et l\'obligent à fermer boutique. | Mais tuer des animaux, pour une raison ou une autre, ne l\'excitait plus vraiment. Il cherchait quelque chose de nouveau. | Après qu\'un doigt humain ait été trouvé dans un de ses emballages de cerf, l\'homme a été chassé de son commerce. | Certains disent qu\'il a surtout aimé dépecer pour les soldats pendant les invasions orques et qu\'il souhaite retrouver cette expérience une fois de plus. | Malheureusement, la guerre a traversé son magasin, laissant derrière elle un certain nombre de carcasses qu\'il n\'aurait pas osé dépecer. | Vivant dans une ville assiégée, il fournissait de la viande aux affamés. Quand on a découvert d\'où venait cette viande, il a été livré aux assiégeants qui, sans le vouloir, l\'ont laissé vivre. | L\'amitié de l\'homme pour les braconniers le rattrapa, le laissant finalement sur la route avec une suite d\'hommes du seigneur local à ses trousses. | Le dépeçage d\'un petit cochon est devenu un scandale quand il s\'est avéré être l\'animal de compagnie d\'un noble. Il s\'est enfui pour sauver son propre lard.} {Quelque chose dans le sang et les tripes convient parfaitement à %name%. Dans ce cas, bienvenue sur le champ de bataille. | %name% voit tout comme une vente potentielle de viande avec un emballage qui respire et bouge. | Beaucoup sont perturbés par la simple présence de %name% et ses yeux trop grands. | %name% est connu pour se mordre la langue et savourer le sang. | Les oreilles de %name% s\'ouvrent dès qu\'un cochon crie. La même chose se produit quand un homme crie. Intéressant. | Il est boucher, mais apparemment il n\'est pas intéressé par le fait de nourrir les animaux.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				4
			],
			Bravery = [
				7,
				5
			],
			Stamina = [
				0,
				4
			],
			MeleeSkill = [
				3,
				2
			],
			RangedSkill = [
				-3,
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r <= 1)
		{
			items.equip(this.new("scripts/items/weapons/butchers_cleaver"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/butcher_apron"));
		}
	}

});

