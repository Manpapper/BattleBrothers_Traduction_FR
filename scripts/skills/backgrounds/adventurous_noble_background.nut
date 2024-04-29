this.adventurous_noble_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.adventurous_noble";
		this.m.Name = "Noble Aventureux";
		this.m.Icon = "ui/backgrounds/background_06.png";
		this.m.BackgroundDescription = "Délaissant souvent une bonne défense contre les armes de jet, les Nobles Aventureux préfèrent inverstir sur de bonnes compétences en mêlée ainsi que sur une détermination élevée.";
		this.m.GoodEnding = "La soif d\'aventure ne quitte jamais l\'âme d\'un homme comme %name%. {Au lieu de retourner dans sa famille noble, il a quitté la compagnie %companyname% et s\'est dirigé vers l\'est à la recherche de bêtes rares. On dit qu\'il est revenu en ville avec la tête de ce qui ressemblait à un lézard géant, mais vous ne croyez pas à de telles bêtises fantastiques. | Il a quitté la compagnie %companyname% et s\'est aventuré vers l\'ouest, naviguant à travers les océans vers des terres inconnues. On ne sait pas où il se trouve aujourd\'hui, mais vous ne doutez pas qu\'il reviendra avec des histoires à raconter. | Il a quitté la compagnie %companyname% et, au lieu de retourner auprès de sa famille noble, il est parti vers le sud. On dit qu\'il a combattu dans une grande guerre civile noble, tué un seigneur de guerre orc, a escaladé la plus haute montagne du pays et écrit actuellement une épopée sur ses voyages. | Le noble a quitté la compagnie %companyname% et, préférant la vie d\'aventure à l\'ennui de la noblesse, il a pris la direction du nord. Il paraît qu\'il dirige actuellement une troupe d\'explorateurs aux confins du monde.}";
		this.m.BadEnding = "%name% est parti de la compagnie %companyname% et a continué son aventure ailleurs. {Il s\'est dirigé vers l\'est, espérant découvrir d\'où viennent les Orcs et les Gobelins, mais le noble n\'a plus donné signe de vie. | Il s\'est dirigé vers le nord dans les étendues enneigées. On dit qu\'il a été vu il y a une semaine, marchant vers le sud cette fois, l\'air plutôt pâle et traînant les pieds plutôt que de marcher. | Il s\'est dirigé vers le sud dans de terribles marais. On dit qu\'une flamme mystérieuse est apparue dans le brouillard et qu\'il s\'est dirigé vers elle. Les hommes qui l\'ont vu ont dit qu\'il avait disparu dans la brume et n\'était jamais revenu. | Il se dirige vers l\'ouest et navigue en pleine mer. Bien que n\'ayant aucune expérience de la mer, il jugea bon de se faire capitaine du bateau. Ils disent que des morceaux de son bateau et des marins morts ont été rejetés sur le rivage pendant des semaines.}";
		this.m.HiringCost = 150;
		this.m.DailyCost = 25;
		this.m.Excluded = [
			"trait.weasel",
			"trait.fear_beasts",
			"trait.clubfooted",
			"trait.irrational",
			"trait.hesitant",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.craven",
			"trait.dastard",
			"trait.fragile",
			"trait.insecure",
			"trait.asthmatic",
			"trait.spartan"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Names = this.Const.Strings.KnightNames;
		this.m.Level = this.Math.rand(1, 3);
		this.m.IsCombatBackground = true;
		this.m.IsNoble = true;
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
		return "{Né noble, mais de rang inférieur | En tant que troisième dans l\'ordre de succession | Jeune noble à l\'effronterie manifeste | En tant qu\'épéiste émérite}, la vie à la cour pour %name% {était devenue ennuyeuse | n\'était pas assez excitante car il se devait de respecter sans fin l\'étiquette qui sied à sa lignée familiale | s\'avérait pénible et il avait clairement la sensation de gâcher les meilleurs moments de sa vie | semblait ennuyeuse et n\'était pas aussi excitante que dans les récits d\'aventures faits d\'épiques batailles, de redoutables bêtes à occire ou de jeunes donzelles à conquérir}. {Portant fièrement les armoiries de sa famille | Encouragé par son frère | Frustré par sa mère | Décidant finalement de changer les choses}, %name% se mit alors en route {afin de gagner sa place | pour se faire un nom | de manière à connaître la gloire sur le champs de bataille | afin de tester ses compétences au combat} et {vivre pleinement la vie telle qu\'il l\'avait rêvée maintes fois derrière les murs du château | ainsi voir enfin toutes les merveilles et les lieux exotiques du monde | finalement gagner sa place dans le monde | enfin être adoubé pour sa valeur | devenir célèbre et aimé dans tout le monde connu | devenir tristement célèbre, craint dans tout le monde connu}.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				15,
				20
			],
			Stamina = [
				0,
				5
			],
			MeleeSkill = [
				10,
				10
			],
			RangedSkill = [
				0,
				0
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				-10,
				-5
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

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/arming_sword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/winged_mace"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/heater_shield"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/shields/kite_shield"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/mail_hauberk"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/helmets/padded_nasal_helmet"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/helmets/nasal_helmet_with_mail"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
	}

});

