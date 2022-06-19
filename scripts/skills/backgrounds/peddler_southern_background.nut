this.peddler_southern_background <- this.inherit("scripts/skills/backgrounds/peddler_background", {
	m = {},
	function create()
	{
		this.peddler_background.create();
		this.m.Bodies = this.Const.Bodies.SouthernMale;
		this.m.Faces = this.Const.Faces.SouthernMale;
		this.m.Hairs = this.Const.Hair.SouthernMale;
		this.m.HairColors = this.Const.HairColors.Southern;
		this.m.Beards = this.Const.Beards.Southern;
		this.m.BeardChance = 90;
		this.m.Ethnicity = 1;
		this.m.Excluded = [
			"trait.superstitious",
			"trait.huge",
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.hate_beasts",
			"trait.iron_jaw",
			"trait.clubfooted",
			"trait.brute",
			"trait.athletic",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dexterous",
			"trait.dumb",
			"trait.deathwish",
			"trait.bloodthirsty"
		];
		this.m.Names = this.Const.Strings.SouthernNames;
		this.m.LastNames = this.Const.Strings.SouthernNamesLast;
	}

	function onBuildDescription()
	{
		return "{D\'une maison à l\'autre, | Autrefois un fier marchand, maintenant | Une nuisance pour la plupart, | Dans les moments difficiles, tout le monde doit tant bien que mal, c\'est pourquoi | Non pas un homme de commerce, mais plutôt le commerce lui-même,} %name% est un simple colporteur. {Il dansera, chantera, se vantera et jouera au roi, dans le seul but de faire cette vente. | Exigeant et inflexible, sa ténacité est remarquable. | Il essaiera de vendre un seau rouillé pour un casque porté par les rois. Cet homme est prêt à vendre n\'importe quoi. | Cet homme va vous vendre des objets que vous ne vouliez même pas à la base. Pas de remboursement, cependant. | Il avait l\'habitude de gagner sa vie en vendant {des chariots usagés | des casseroles, poêles et bocaux}, jusqu\'à ce qu\'une concurrence féroce le pousse à la faillite - en lui cassant le bras.} {Se vendre est ce que cet homme frêle fait de mieux, bien que peu de gens croient son discours sur \"l\'art de l\'épée et le courage résolu\". | Il est censé distribuer des \"coupons\" pour ses services, quels qu\'ils soient. Mais il n\'est pas cher, et n\'importe quelle entreprise de nos jours a besoin d\'un corps chaud, quelle que soit sa valeur réelle. | S\'il est recruté, il promet que vous aurez une réduction spéciale sur une potion améliorant la virilité. | L\'homme baisse la voix et vous dit qu\'il a une bonne affaire concernant des pointes de flèches rouillées, juste pour vous. Il a l\'air déçu par votre manque d\'intérêt. | Cet homme connaît un homme qui connaît un homme qui connaît un homme. Ces trois inconnus sont potentiellement meilleurs que lui au combat. | C\'est dommage qu\'un homme ne puisse pas se battre avec ses mots de nos jours. %name% serait inarrêtable.}";
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/dagger"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/oriental/cloth_sash"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/oriental/southern_head_wrap"));
		}
	}

});

