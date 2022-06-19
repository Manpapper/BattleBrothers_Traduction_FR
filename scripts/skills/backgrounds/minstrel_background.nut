this.minstrel_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.minstrel";
		this.m.Name = "Ménestrel";
		this.m.Icon = "ui/backgrounds/background_42.png";
		this.m.BackgroundDescription = "Un bon ménestrel chantera une saga pour inspirer les hommes, jouera de la flûte pour les calmer, ou les divertira avec des poèmes autour du feu de camp. Le luth n\'est pas une arme et les ménestrels ne sont souvent pas habitués au travail physique ou aux effusions de sang.";
		this.m.GoodEnding = "Ah, %name%. Quel atout pour la compagnie %companyname% ! Le ménestrel est non seulement devenu un excellent combattant, mais il a également joué un rôle crucial dans le maintien du moral des hommes dans les moments les plus difficiles. Poète et acteur dans l\'âme, il s\'est finalement retiré de la compagnie et a créé une troupe de théâtre. Il joue actuellement des pièces pour la noblesse et les profanes. Le ménestrel ne s\'en rend pas encore compte, mais son esprit ludique et ses commentaires acérés rapprochent lentement les diverses classes sociales.";
		this.m.BadEnding = "N\'ayant jamais été un combattant dans l\'âme, %name% le ménestrel a rapidement quitté la compagnie %companyname% qui est en déclin. Lui et un groupe de musiciens et de bouffons passent leurs soirées à se produire devant des nobles ivres. Vous avez réussi à voir l\'une de ces performances par vous-même. %name% a passé la majeure partie du temps à se faire réprimander par les personnes ivres et à se faire jeter des os de poulet à moitié rongés. Un des nobles a même pensé qu\'il serait drôle de lâcher un chien sur un des bouffons. On pouvait voir les rêves du ménestrel mourir dans ses yeux, mais le spectacle a continué.";
		this.m.HiringCost = 65;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.huge",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.craven",
			"trait.dumb",
			"trait.strong",
			"trait.tough",
			"trait.dumb",
			"trait.brute",
			"trait.clubfooted",
			"trait.dastard",
			"trait.insecure",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Minstrel",
			"the Skjald",
			"the Poet",
			"Songbird",
			"the Troubadour",
			"the Chorine",
			"the Lover",
			"the Bard"
		];
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "\"{Je peux brandir une épée et fendre une hache, | On peut me demander une tâche, | Dieu à droite, une flasque à gauche,} {et je dis, \"Vous interrogez un homme qui ne porte pas de masque?\". | et donc je dois agir vite, mais pas trop vite non plus.} {Les ours en peluche je fixais, | Dans mes pantalons effilochés j\'ai mis, | Le long des routes boueuses mes bottes dérapent,} {et donc de beaucoup de choses je suis débarrassé. | la vérité ! Mon talent honteux est de - férocement ! - tricoter.} {Alors emmène-moi dans ton aventure, | Amenez-moi avec vos hommes qui s\'agitent et grimpent, | Donne-moi ton bouclier et ce truc qui a la forme de mon membre,} {et allons dire à la peur un adieu mémorable! | et allons - oh, ow ! J\'ai une écharde! | et que nous arrivions, tous et chacun, à un prochain hiver en bonne santé!}\". {L\'homme parle un charabia. | Ça rime!}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-5,
				-3
			],
			Bravery = [
				5,
				10
			],
			Stamina = [
				-10,
				-10
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
				5
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local armor = this.new("scripts/items/armor/linen_tunic");
		armor.setVariant(this.Math.rand(3, 4));
		items.equip(armor);
		local r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}

		if (this.Math.rand(1, 100) <= 60)
		{
			items.equip(this.new("scripts/items/weapons/lute"));
		}
	}

});

