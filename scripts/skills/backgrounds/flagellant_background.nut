this.flagellant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.flagellant";
		this.m.Name = "Flagellant";
		this.m.Icon = "ui/backgrounds/background_26.png";
		this.m.BackgroundDescription = "Les flagellants sont très déterminés dans ce qu'ils font, et ont une grande tolérance à la douleur, mais leur travail a souvent laissé leur corps marqué à vie.";
		this.m.GoodEnding = "One of the more disturbing members of the group, %name% the flagellant at least put aside the whip long enough to bring blades to your enemies. Although he was a capable if not unsettlingly diligent mercenary, it became increasingly obvious that his habits would be the end of him. After another night of harsh personal repudiation, the company found the man unconscious and nearly bleeding out yet again. Hoping to save %name% from himself, they dropped the flagellant off at a monastery where he eventually woke to painful confusion. A kind monk nursed him to health and taught him the ways of peaceful religiosity. To this day, %name% walks the cloisters, giving tempered talks to the young and sparing them from notions of savage spirituality.";
		this.m.BadEnding = "With the company rapidly declining, many mercenaries turned to desperate measures. %name% the flagellant was one such measure. Due to chaos and confusion, some men came to believe %name% could lead them to honor and salvation. A handful of survivors broke off from the %companyname% and went mad, joining his cult of savage spirituality. A howling %name% at their helm, the converts wander aimlessly, sulking half-bent across the earth, rinds of raw hides for backs.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 6;
		this.m.Excluded = [
			"trait.weasel",
			"trait.clubfooted",
			"trait.tough",
			"trait.strong",
			"trait.disloyal",
			"trait.insecure",
			"trait.cocky",
			"trait.fat",
			"trait.fainthearted",
			"trait.bright",
			"trait.craven",
			"trait.greedy",
			"trait.gluttonous"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsOffendedByViolence = true;
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
		return "{Les dieux ont pitié des hommes, incitant beaucoup d'entre eux, un peu comme %name%, à rechercher leur faveur. | Analphabète et né dans la pauvreté, %name% a trouvé refuge dans les contes des dieux. | Toujours homme à dévorer les livres, %name% ne tarde pas à découvrir les textes des dieux. | Certains disent que les dieux nous parlent et, si c'est vrai, ils ont certainement parlé à %name%. | Avec l'apparition de nouveaux cultes dans les régions sauvages, %name% est retourné à la familiarité des dieux. | Élevé par son père violent, %name% a passé une grande partie de ses premières années à soigner les blessures causées par de bons coups de fouet. Les dieux approuveraient.} {Quand la guerre est arrivée dans le pays, les dieux lui ont dit d'y prendre part pour une plus grande justice. | Alors que les sectes répandent leur vile parole comme la maladie sur un rat, %nom% a jugé bon de prendre les armes et de combattre l'hérésie. | S'éloignant de sa foi, il a commis un crime horrible dans %randomtown% - en trouvant la compagnie avec un homme. Tout en se flagellant chaque nuit, il cherche à se racheter. | N'ayant entendu qu'une simple rumeur concernant un lieu saint, le pèlerin a pris son bâton et ses provisions pour le rechercher. | Maintenant que la guerre est revenue dans le pays, le fidèle des dieux a souhaité en découvrir la raison, par la prière et les moyens corporels. | Une nuit passée dans une grotte a révélé au croyant que les dieux exigeaient du sang. %name% n'était pas du genre à refuser leur appel. | Après que des pillards aient pillé les coffres de son église, la quête de %name% était de les remplir.} {Alors que les lois de l'univers se plient à une guerre qui dévore le monde, un thaumaturge comme %name% pourrait être utile. | Il porte un fouet en cuir recouvert de verre. Ce n'est pas pour vos ennemis, dit-il, mais pour la purification. Intéressant. | Il professe sa haine du mal, mais pour quelques couronnes, %name% peut être persuadé de rendre n'importe quoi \"maléfique\". | Cet homme choisit la voie difficile, c'est sans doute pourquoi il a jugé bon de rejoindre une bande de mercenaires. | Si %name% avait le pouvoir, vous pensez qu'il purgerait le monde entier. Heureusement, c'est un simple homme. | Les discussions sur les dieux peuvent être un peu ennuyeuses, mais la passion ardente de %name% se prête bien au champ de bataille. | Si amoureux du monde des dieux, ce n'est pas une surprise que le pèlerin voit le vrai monde rempli d'ennemis.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-5
			],
			Bravery = [
				12,
				12
			],
			Stamina = [
				5,
				10
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

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		this.updateAppearance();
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local body = actor.getSprite("body");
		local tattoo_body = actor.getSprite("tattoo_body");
		tattoo_body.setBrush("scar_01_" + body.getBrush().Name);
		tattoo_body.Color = body.Color;
		tattoo_body.Saturation = body.Saturation;
		tattoo_body.Visible = true;
	}

	function onAdded()
	{
		this.character_background.onAdded();

		if (this.Math.rand(0, 3) == 3)
		{
			local actor = this.getContainer().getActor();
			actor.setTitle(this.Const.Strings.PilgrimTitles[this.Math.rand(0, this.Const.Strings.PilgrimTitles.len() - 1)]);
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 2);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_flail"));
		}
		else if (r == 2)
		{
			items.equip(this.new("scripts/items/weapons/reinforced_wooden_flail"));
		}

		r = this.Math.rand(1, 4);

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 2)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		if (r == 3)
		{
			items.equip(this.new("scripts/items/armor/sackcloth"));
		}

		if (r == 4)
		{
			items.equip(this.new("scripts/items/armor/monk_robe"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/hood"));
		}
	}

});

