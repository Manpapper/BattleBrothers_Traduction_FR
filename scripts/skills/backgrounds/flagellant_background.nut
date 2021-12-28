this.flagellant_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.flagellant";
		this.m.Name = "Flagellant";
		this.m.Icon = "ui/backgrounds/background_26.png";
		this.m.BackgroundDescription = "Flagellants have a high resolve in what they do, and a high tolerance for pain, but their work has often left their bodies scarred for life.";
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
		return "{The gods pity men, spurring many, not unlike %name%, to seek their favor. | Illiterate and born to poverty, %name% found refuge in tales of the gods. | Always a man to devour books, it wasn\'t long until %name% discovered texts of the gods. | Some say the gods speak to us and, if true, they definitely spoke to %name%. | With new cults springing up in the wilds, %name% returned to the familiarity of the gods. | Raised by his firebrand father, %name% spent much of his early years nursing wounds from good floggings. The gods would approve.} {When war came to the land, the gods told him to take part for greater justice. | As cultists spread their vile word like disease on a rat, %name% saw fit to take up arms and battle the heresy. | Straying from his faith, he committed a horrific crime in %randomtown% - finding company with a man. While flagellating himself nightly, he seeks redemption. | Hearing but a mere rumor of a holy place, the pilgrim took up staff and supplies to seek it out. | Now that war has returned to the land, the gods devotee wished to find out why, through prayer and corporeal means. | A night spent in a cave revealed to the believer that the gods demanded blood. %name% was not one to refuse their beckoning. | After raiders looted the coffers of his church, %name%\'s quest was to refill the pure purses.} {As the laws of the universe bend to a world-consuming war, a thaumaturge like %name% might be useful to have around. | He carries a whip with glass-barbed leather. This is not for your enemies, he states, but for purity. Interesting. | He professes to hate evil, but for a few crowns %name% can be persuaded to make anything \'evil\'. | This man seeks the difficult road, no doubt why he saw fit to join a mercenary band. | If %name% had the power, you believe he\'d purge the entire world. Thankfully, he is a mere man. | Talks of the gods might be a tad irksome, but %name%\'s fiery passion lends itself well to the battlefield. | So enamored with the world of the gods, it\'s not much of a surprise that the pilgrim sees the real one filled with enemies.}";
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

