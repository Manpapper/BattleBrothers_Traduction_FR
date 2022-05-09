this.butcher_southern_background <- this.inherit("scripts/skills/backgrounds/butcher_background", {
	m = {},
	function create()
	{
		this.butcher_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.Ethnicity = 1;
		this.m.BeardChance = 60;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Après la mort de son père, %name% a repris la boucherie familiale dans %randomtown%. | Ayant grandi dans la pauvreté, %name% a rapidement appris à tuer et à dépouiller les animaux, pour finalement fonder une boucherie. | Avec les sécheresses qui ont ruiné les terres agricoles, la boucherie de %name% s\'est développée dans %randomcitystate%. | Toujours aussi étrange, %name% s\'est mis à la boucherie non seulement pour le profit, mais aussi pour le plaisir. | Sourire jusqu\'aux oreilles, %name% n\'a jamais eu l\'air aussi heureux que lorsque sa boutique a ouvert et qu\'il a reçu sa première commande de porcs vivants en stock. | En tant que boucher, %name% a passé des années à vider les boyaux de lapins morts et à décapiter des poissons parfois morts.} {Mais les rumeurs de torture animale ont fini par pousser le boucher à abandonner son commerce. | Vu les terribles rumeurs de magie noire qui circulaient déjà, il n\'a pas fallu longtemps pour que les gens commencent à s\'interroger sur la provenance de ses viandes et l\'obligent à fermer boutique. | Mais tuer des animaux, pour une raison ou une autre, ne l\'excitait plus vraiment. Il cherchait quelque chose de nouveau. | Après qu\'un doigt humain ait été trouvé dans un de ses emballages de cerf, l\'homme a été chassé de son commerce. | Certains disent qu\'il a surtout apprécié d\'être le boucher des hommes du vizir lors d\'une de leurs campagnes contre les tribus du désert et qu\'il souhaite renouer avec cette expérience. | Malheureusement, la guerre a traversé son magasin, laissant derrière elle un certain nombre de carcasses qu\'il n\'aurait pas osé dépecer. | Le dépeçage d\'un petit cochon est devenu un scandale quand il s\'est avéré être l\'animal de compagnie d\'un noble. Il s\'est enfui pour sauver son propre lard.} {Quelque chose dans le sang et les tripes convient parfaitement à %name%. Dans ce cas, bienvenue sur le champ de bataille. | %name% voit tout comme une vente potentielle de viande avec un emballage qui respire et bouge. | Beaucoup sont perturbés par la simple présence de %name% et ses yeux trop grands. | %name% est connu pour se mordre la langue et savourer le sang. | Les oreilles de %name% s\'ouvrent dès qu\'un cochon crie. La même chose se produit quand un homme crie. Intéressant. | Il est boucher, mais apparemment il n\'est pas intéressé par le fait de nourrir les animaux.}";
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

