this.farmhand_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.farmhand";
		this.m.Name = "Fermier";
		this.m.Icon = "ui/backgrounds/background_09.png";
		this.m.BackgroundDescription = "Les fermiers sont habitués à un travail physique difficile.";
		this.m.GoodEnding = "The former farmhand, %name%, retired from the %companyname%. The money he made was put toward purchasing a bit of land. He spends the rest of his days happily farming and starting a family with way too many children.";
		this.m.BadEnding = "The former farmhand, %name%, soon left the %companyname%. He purchased a bit of land out {south | north | east | west} and was doing quite well for himself - until noble soldiers hanged him from a tree for refusing to hand over all his crops.";
		this.m.HiringCost = 90;
		this.m.DailyCost = 10;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.clubfooted",
			"trait.asthmatic"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
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
		return "{Labourer le sol est un travail difficile, qui requiert le sang et la sueur d\'hommes plus robustes. | Chaque ferme du pays a besoin d\'un certain nombre d\'hommes robustes pour travailler dans les champs.  | L\'homme met sa sueur dans la terre pour se nourrir, et il se nourrit pour mettre sa sueur dans la terre le lendemain. | Quel que soit le temps, une ferme a besoin d\'être travaillée. | Porcheries, étables et enclos non clôturés, tels sont les rêves et les cauchemars des fermiers. | Alors que certains hommes gagnent leur vie en tuant, d\'autres regardent en dessous de leurs deux pieds, se demandant quelles récoltes le sol peut produire. | Une race spéciale d\'hommes est issue des éleveurs et des fermiers. Robustes, résolus, travailleurs. | Avec un tel besoin de nourriture, il n\'est pas étonnant que les agriculteurs soient le type d\'homme le plus répandu dans tout le pays. | Un fermier déteste voir sa terre fertilisée en sang, mais cela devient de plus en plus courant de nos jours. | En temps de guerre, les fermes sont des points stratégiques pour les armées. Pas seulement pour se nourrir, mais pour recruter des hommes forts dans qui travaillent sur ces terres. | À mesure que les villes se développent et s\'éloignent de l\'arrière-pays, les citoyens oublient souvent à qui ils doivent la gratitude d\'avoir des ventres pleins.} %name% {est un fermier costaud et couvert de sueur. | vient de la banlieue de %randomtown% où il conduisait des charrues et dressait des chevaux. | connaît plusieurs sortes de houes, que n\'importe quel fermier peut manier avec aisance. | a grandi dans l\'une des nombreuses fermes de la région. | a passé de nombreuses années à récolter les cultures qui nourrissent tout le monde dans le pays. | a travaillé comme ouvrier agricole dans une simple ferme. | s\'est mis à l\'agriculture après la fermeture de son service de transport en bateau. | est devenu ouvrier agricole pour aider à nourrir sa douzaine d\'enfants et ses deux épouses. | s\'est lancé dans l\'agriculture pour se remplir le ventre. | possède la carrure trapue la mieux adaptée pour planter, récolter et survivre aux hivers.} {Malheureusement, il n\'a pas fallu longtemps pour que la guerre et les conflits trouvent sa ferme. | Mais les mauvaises récoltes l\'ont chassé des fermes. | Malheureusement, sa ferme a été l\'une des premières à être attaquée en ces temps difficiles. | La nouvelle de la violence à venir l\'a cependant poussé à abandonner la vocation paisible de l\'agriculture. | Les sécheresses, toujours aussi inopportunes, ont maintenant poussé l\'homme à abandonner son travail. | Non payé pour son travail, il finit par abandonner la vie à la ferme. | Avec plus de couronnes que jamais dans les activités liés à la mort, l\'homme s\'est facilement éloigné de ses cultures hétéroclites. | Un jour, il a réalisé que son corps robuste avait plus de valeur en coupant des têtes qu\'en trayant des vaches. | Après que des pillards aient pillé ses récoltes, il en a eu assez et a quitté la vie de ferme pour de bon. | Après que le temps ait gâché sa récolte, le fermier a décidé de choisir une vocation qui ne soit pas entièrement basée sur les caprices de Mère Nature. | Il paraît qu\'il a vraiment couché avec la fille du fermier. Quelle surprise, il n\'est plus à la ferme.} {%name% se tient devant vous en bonne santé comme vous n\'avez jamais vu. | Les vaches lui manquent, c\'est vrai, mais %name% devrait s\'adapter facilement à la vie difficile des mercenaires. | Grandir dans une ferme donne à un homme tous les nutriments dont il a besoin, et %name% en a certainement profité. | Un jour, %name% a pris un coup de pied de mule au visage. Son pied étant cassé, ils ont dû piquer l\'animal. | Si les hommes étaient des arbres, %nom% ne tomberait jamais. Ou quelque chose de gracieux comme ça. | Ne laissez pas son simple passé vous tromper, %name% pourrait parfaitement faire le poids face à n\'importe quel lutteur ou combattant. | %name% a beaucoup de points communs avec les animaux de trait. Il suffit de lui indiquer le bon chemin. | À en juger par sa taille, il devait y avoir beaucoup de viande dans le maïs que %name% a passé toute sa vie à manger. | %name% est assez grand pour tordre le cou d\'un gars comme si c\'était le pis d\'une vache.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				12,
				10
			],
			Bravery = [
				-2,
				-3
			],
			Stamina = [
				10,
				20
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/pitchfork"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/wooden_flail"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}
		else
		{
			local item = this.new("scripts/items/armor/linen_tunic");
			item.setVariant(this.Math.rand(6, 7));
			items.equip(item);
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/straw_hat"));
		}
	}

});

