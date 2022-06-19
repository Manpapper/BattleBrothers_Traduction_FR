this.retired_soldier_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.retired_soldier";
		this.m.Name = "Soldat à la retraite";
		this.m.Icon = "ui/backgrounds/background_24.png";
		this.m.BackgroundDescription = "Les soldats retraités ont généralement une bonne expérience de la guerre, et leur détermination n\'est pas facile à ébranler. Cependant, l\'âge peut avoir eu un impact sur leurs attributs physiques.";
		this.m.GoodEnding = "%name% est de nouveau parti, cette fois du métier de mercenaire au lieu de celui de soldat. Laissant la compagnie %companyname% derrière lui, il a construit une cabane dans les bois et profite de la paix et du calme, restant aussi loin que possible de toutes batailles.";
		this.m.BadEnding = "Fatigué de toutes ces combats, %name% a quitté la compagnie %companyname% qui déclinait rapidement et s\'est construit une cabane dans les bois. Malheureusement, des vagabonds ont attaqué. On raconte qu\'il a été retrouvé a terre, couvert de sang, entouré de six hommes morts et d\'un homme qui se tenait debout, un garçon nerveux à la gueule fracassée qui agitait une épée vers le vieil homme mourant.";
		this.m.HiringCost = 140;
		this.m.DailyCost = 15;
		this.m.Excluded = [
			"trait.weasel",
			"trait.swift",
			"trait.clubfooted",
			"trait.irrational",
			"trait.gluttonous",
			"trait.disloyal",
			"trait.clumsy",
			"trait.tiny",
			"trait.insecure",
			"trait.fainthearted",
			"trait.craven",
			"trait.bleeder",
			"trait.dastard",
			"trait.hesitant",
			"trait.fragile",
			"trait.iron_lungs",
			"trait.tough",
			"trait.strong",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Oldguard",
			"the Old",
			"the Sergeant",
			"the Veteran",
			"the Soldier"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.Old;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = this.Math.rand(2, 3);
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
			}
		];
	}

	function onBuildDescription()
	{
		return "Autrefois {un sergent | un garde royal | un soldat dévoué | un armurier respecté | un combattant en première ligne | un soldat | un laquais} dans l\'armée d\'un seigneur local, %fullname% {a pris sa retraite après avoir reçu une flèche dans le genou | a été remplacé par un jeune aspirant | a été renvoyé après s\'être endormi pendant la garde | a pris sa retraite après un long service exemplaire | a été blessé au combat et contraint de prendre sa retraite | s\'est lassé des batailles et des bains de sang, mettant officiellement fin à son service avant que cela ne ruine son moral | a combattu les féroces hordes d\'orcs, les missions l\'obligeant finalement à prendre sa retraite}. {Il a enfermé tous ses souvenirs son équipement dans un coffre, avec l\'intention de ne plus jamais reprendre l\'un ou l\'autre | Il a rangé l\'épée et le bouclier dans son bureau comme de simples reliques d\'un passé militaire | Il a suspendu ses armes au-dessus de la cheminée comme un rappel silencieux de l\'homme qu\'il était | Mais un nouveau chapitre de sa vie l\'attendait, un chapitre où il n\'aurait pas besoin d\'une épée pour faire sa besogne | Avec de nombreuses années de service derrière lui, il pouvait enfin avoir un peu de paix et de tranquillité | Sans les hurlements d\'un exercice militaire, sa vie n\'a jamais été aussi calme}. {Pendant de nombreuses années, il a vécu une vie heureuse avec sa femme bien-aimée, jusqu\'à ce qu\'elle décède de vieillesse. N\'ayant personne vers qui se tourner | Ce n\'est que lorsqu\'il a découvert que ses anciens camarades avaient été brutalement tués dans une embuscade | C\'est en entendant des rumeurs d\'une grande invasion sur le point de détruire sa patrie, | Il a essayé de vivre comme un fermier pendant un certain temps, mais chaque jour il regrettait d\'avoir une bonne épée en main et de ne pas s\'en servir. C\'est pour cela | Mais la vie en dehors de l\'armée ne lui convient pas, car il se sent oisif et inutile. C\'est sur ce ressenti, | Pendant un temps, il s\'est senti à l\'aise. Mais c\'est quand il a compris que le pays était dévasté par la guerre, | Le temps passé loin de la guerre a été de courte durée, car elle est vite revenue à lui. C\'est sur ce constat | C\'est quand %name% a compris qu\'il s\'ennuyait dans sa ferme,} qu\'il a repris les armes une fois de plus. Même si {ses plus beaux jours sont passés depuis longtemps | il n\'est plus en aussi bonne forme physique qu\'avant | sa constitution n\'est plus celle d\'un jeune homme | il n\'est plus le jeune combattant téméraire qu\'il était autrefois | le temps passé loin du service a affaibli ses compétences}, {ses compétences en combat à l\'épée sont encore suffisantes pour battre n\'importe quel jeune fanfaron | il sait encore comment on se bat sur le champ de bataille | son expérience n\'a pas d\'égal | il peut compter sur l\'expérience de combat de toute une vie  | Il est impatient de retrouver ses frère | il est impatient de retrouver le chemin du combat | son envie de retrouver les combats est reflétée par ses capacités à se battre réellement | il sait encore une chose ou deux sur la mise en place d\'un mur de bouclier}.";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-15
			],
			Bravery = [
				13,
				10
			],
			Stamina = [
				-10,
				-10
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				5,
				0
			],
			MeleeDefense = [
				5,
				8
			],
			RangedDefense = [
				5,
				8
			],
			Initiative = [
				-5,
				-10
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
			items.equip(this.new("scripts/items/weapons/shortsword"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/hand_axe"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/boar_spear"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/weapons/falchion"));
		}

		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/shields/wooden_shield"));
		}

		r = this.Math.rand(0, 3);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/padded_leather"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/worn_mail_shirt"));
		}

		r = this.Math.rand(0, 8);

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
			items.equip(this.new("scripts/items/helmets/mail_coif"));
		}
		else if (r == 3)
		{
			items.equip(this.new("scripts/items/helmets/rusty_mail_coif"));
		}
		else if (r == 4)
		{
			items.equip(this.new("scripts/items/helmets/aketon_cap"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/full_aketon_cap"));
		}
	}

});

