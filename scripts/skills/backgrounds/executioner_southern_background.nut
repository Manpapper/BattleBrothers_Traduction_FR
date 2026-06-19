this.executioner_southern_background <- this.inherit("scripts/skills/backgrounds/executioner_background", {
	m = {},
	function create()
	{
		this.executioner_background.create();
		this.m.Excluded.push("trait.superstitious");
		this.m.Bodies = this.Const.Bodies.SouthernBig;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 60;
		this.m.Ethnicity = 1;
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{Autrefois bourreau au sein des nombreuses tribus nomades du Sud, %name% a été banni {pour une décapitation qui a terriblement mal tourné | lorsqu\'on a découvert qu'il avait tué la mauvaise personne | après avoir simulé la mort d\'un ami}. Sans but précis, il s\’est retrouvé à %randomcitystate% et a reprit son métier au service des vizirs. | Un bourreau, %name% avait pour mission de procéder à la décapitation, à la pendaison, à l\'écartèlement et à tous les autres châtiments infligés aux criminels jugés indignes de rembourser leurs dettes envers le Gilder de leur vivant, ainsi qu'à ceux à qui l\'on avait donné une chance mais qui avaient échoué. | %name% travaillait pour %randomvizier% comme bourreau, rendant une justice effroyable aux criminels du Sud. | À en juger par sa capuche caractéristique, il ne fait aucun doute que %name% est un bourreau. À en juger par son air sévère, on voit bien qu\’il exerce ce métier depuis un certain temps.} {Dans les cités-États, cependant, même les criminels ont plus de valeur vivants que morts, et il se retrouva bientôt à court de travail et d'argent. | Un jour, on lui confia la tâche de trancher la nuque d’un autre bourreau qui avait \"gâché\" une exécution en laissant le condamné anticiper le coup fatal et hurler. %name% s\’acquitta de sa mission en silence, puis décida qu\’il était temps de changer de métier. | Pendant de nombreuses années, il s\'est satisfait de son travail, mais un jour, on lui a confié la tâche de {pendre un jeune garçon qui avait volé de la nourriture au marché | décapiter une belle concubine qui avait déplu à son maître | noyer un vieil homme trop faible pour rester debout}. Il a rempli son devoir, mais s'est rendu compte qu'il n\'avait plus le goût de ce métier par la suite. | Bien qu\'il fût plutôt satisfait de sa profession, il apprit que tous ses prédécesseurs avaient fini par s\'endetter ou avaient été exécutés après avoir déplu à leur employeur. Voyant le danger qui le guettait, il se mit à chercher un nouveau métier.} {Ne sachant pas trop quoi faire d'autre, %name% a estimé que le métier de mercenaire correspondait bien à ses compétences. | Estimant qu\’il serait tout aussi respecté en tant que Crownling, mais mieux payé, %name% s’est désormais lancé dans une carrière de mercenaire. | Habitué au sang comme aux lames, le métier de mercenaire s'impose comme la suite logique pour %name%. | %name% s'est essayé à plusieurs métiers avant de décider que ses talents particuliers convenaient mieux au métier sanglant, mais bien rémunéré, de mercenaire.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local weapons = [
			"weapons/hatchet",
			"weapons/hand_axe",
			"weapons/exesword",
			"weapons/woodcutters_axe",
			"weapons/oriental/two_handed_scimitar",
			"weapons/oriental/two_handed_saif"
		];

		if (this.Const.DLC.Wildmen)
		{
			weapons.extend([
				"weapons/bardiche"
			]);
		}

		items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		local armor = [
			"armor/leather_wraps"
		];

		if (this.Math.rand(0, 100) < 50)
		{
			items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
		}

		local helmets = [
			"helmets/executioner_hood",
			"helmets/executioner_hood_open"
		];
		items.equip(this.new("scripts/items/" + helmets[this.Math.rand(0, helmets.len() - 1)]));
	}

});

