this.tailor_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.tailor";
		this.m.Name = "Tailor";
		this.m.Icon = "ui/backgrounds/background_48.png";
		this.m.BackgroundDescription = "Tailors are not used to hard physical labor.";
		this.m.GoodEnding = "What was a tailor doing in a mercenary company? A good question, but %name% certainly answered it well by killing so many enemies they could\'ve made an epic tapestry out of story. After a few good years in the company, he eventually left to start up a business creating clothes for nobility. His name is world-renowned, well, the known-world-renowned, and he gets so much business he\'s making a very different killing these days.";
		this.m.BadEnding = "A tailor at heart, it didn\'t take much to compel %name% to bail from the quickly sinking company. He left to go start a business, but was kidnapped along the way by a group of brigands. When they threatened to kill him, he pretended to be a simple and weak tailor and showed his talents in creating clothes. Impressed, the raggedly dressed outlaws took him into their band. A few days later they were all dead and this \'meek\' man walked out of their camp with a bit of red on him. He started his business a week later and is doing well to this day.";
		this.m.HiringCost = 50;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.huge",
			"trait.hate_undead",
			"trait.athletic",
			"trait.deathwish",
			"trait.clumsy",
			"trait.fearless",
			"trait.spartan",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dumb",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Peculiar",
			"the Tailor",
			"the Particular",
			"the Fine",
			"Silkworm"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Thick;
		this.m.IsLowborn = true;
	}

	function onBuildDescription()
	{
		return "{%name% was always curious about fabrics, seeing more science in a linen cloth than {a diviner would in the sands of the desert. | a haruspex would in a toad\'s entrails. | an alchemist would in a mortar and pestle.} | %name% was always an odd boy growing up, fancying a good silk dress instead of the girl beneath it. | Son to a {mining father | squire | knight | farmhand}, %name%\'s turn toward fashioning clothes was a surprise to all. | While %name%\'s sisters fancied being warriors and heroes, %name% thought of himself as a future dresser of kings. | %name% spent much of his youth in the company of girls, but not for the reasons one might think. | %name% always fancied animals, particularly how they would look as a good coat or scarf. | As tunics and shirts grew popular, %name% turned to tailoring to make a crown or two. | With a surge in pantaloons popularity, %name% went from being a tanner to a tailor to make more money. | %name% hails from a faraway land where how a man dresses is more important than how he fights. | Tailoring is the science of colors and fabrics, by which standards %name% is renowned. | Good with measuring and calculating, %name% turned his mathematical prowess to tailoring to earn as much as he could. | %name%\'s career in tailoring started when his mother pushed him into the vocation to dodge a passing noble\'s conscription. | %name% took up tailoring to honor his father, a tailor who was killed by an unhappy customer. | Widowed by war, %name%\'s mother taught him how to put his hands to better use in tailoring instead of killing.} {When raiders attacked his home, %name% dressed everyone up in clever disguises. The town was destroyed, but not a soul was lost. | He spent many years dressing royalty until a fashion faux pas led his being exiled. | Unfortunately, a man fancying a good fabric, as %name% is wont to do, left the tailor ostracized from many a village. | He tried to make his break in the big cities, but sadly he just could not compete with the other tailors. | When a lord organized an army, %name% handled the clothes, giving the soldiers proper uniforms. | But a fierce competition between tailors led to a linen-wrapped deadman and %name% coincidentally leaving his shop behind. | Sadly, robbers ransacked his shop and, with the wars going on, it would be impossible to restock. | But when he sheared a sheep that did not belong to him, %name% was kicked out of town. | He once choked out a would-be thief with a cord of measuring wire. So he says, anyway. | But dressing unlikeable and unfriendly nobility eventually {bored him. | wore on him.} | Once tasked with making a tunic embroidered with epic feats, %name% wondered what the outside world was really like. | Designing a dress adorned with {epic quests | epic feats}, %name% wondered if maybe he should be the one they wove stories about.} Now the tailor looks for a new life, no matter where it takes him. {Maybe he can dress the unit well, or something. | He\'s particular and peculiar, peppering everyone with clothing criticisms. | He\'s no natural soldier, but he appraises a man\'s attire as if he\'s about to go to war with it. | The way he measures and calculates for dressing, it\'s too bad %name% wasn\'t a siege engineer. | While hardly a soldier, %name%\'s earnest love for tailoring is to be admired. | %name%\'s knowledge of various cloths is seriously impressive. | A bit on the nimby-pimby side, %name% has the footwork of a swordfighter, but the swordfighting of a soft breeze. | %name% would seem very out of place in a suit of armor, but boy is he going to need one. | As it turns out, %name% can in fact make a silk purse out of a sow\'s ear. | Don\'t let his vocation fool you, %name% is more deft with his hands than some {cardsharks | jugglers | pickpockets}. | Tailors don\'t seem fit for combat, but then again neither do most of the men you run across these days. | A tailor seems ill-fit for combat, yet for some reason you find the finest soldiers in the strangest of places. | With an eye {for calculations | for measuring}, %name% is a lot smarter than he lets on at first glance.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-3,
				0
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-5,
				-5
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
		local r;
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/linen_tunic"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});

