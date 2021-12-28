this.cripple_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.cripple";
		this.m.Name = "Cripple";
		this.m.Icon = "ui/backgrounds/background_51.png";
		this.m.BackgroundDescription = "The only thing swift about a cripple is his expected demise in a real battle.";
		this.m.GoodEnding = "It\'s shocking that a man of %name%\'s stature survived at all, but the cripple did retire from the %companyname% with a sizeable stack of crowns. He runs an orphanage these days, spending his crowns to help the world\'s broken and abandoned children. That, or it\'s just a front for cheap labor. Can\'t be too sure these days.";
		this.m.BadEnding = "When you left the %companyname%, there was one thing you were almost certain of: that damned cripple, %name%, wouldn\'t last long. Despite all odds, he did survive. Long enough in fact to retire himself, albeit departing with about as many crowns as he had when he joined up. You\'ve no idea what became of him, but surely he\'s dead by now. Surely, right?";
		this.m.HiringCost = 30;
		this.m.DailyCost = 3;
		this.m.Excluded = [
			"trait.huge",
			"trait.weasel",
			"trait.lucky",
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.cocky",
			"trait.fat",
			"trait.greedy",
			"trait.athletic",
			"trait.impatient",
			"trait.quick",
			"trait.swift",
			"trait.dexterous"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Initiative
		];
		this.m.Titles = [
			"the Cripple",
			"the Maimed",
			"the Broken",
			"the Grotesque"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
			},
			{
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Is always content with being in reserve"
			}
		];
	}

	function onBuildDescription()
	{
		return "%name% {hobbles toward you like a mangy dog | greets you with a hand missing numerous fingers | smiles at you with a toothless grin | carries the slouching posture of a man with a broken back | wobbles on two very stiff, possibly even wooden legs | uses a cane to walk toward you | crawls toward you at first, but then rises to his feet with all the grace of a drunk on church steps | has bones that creak and croak with every step | carries an arm in a sling, and has a cane standing in support for one of his legs | has a smashed nose and two blackened eyes | looks like someone tried to scalp and burn him alive | has flesh that smells partly cooked, his eyes wincing with every step he takes toward you | is missing two ears, though the holes still hear | reeks of shit and urine | is missing one eye, and the other wanders severely | has two lazy eyes and a crooked, gap-filled smile}. He explains that {he was once a mason, but that he was attacked by a madman for trying to replicate his work | he once donned armor as a knight, but that cruel fate has taken all of that from him | once upon a time he was a nobleman, but his poor vocabulary suggests this may be a lie | he was a peddler once, but the sale of a lobo-rail ended with him at the mercy of an angry town mob | he dabbled in cultism, but when he bailed they punished him for it | he was once a monk, but {cultists attacked his church | a spat with other monks had him severely punished | brigands attacked him for crucifying one of their own} | he used to brawl for lords, but a beatdown by other fighters left him crippled | he used to wander the land for jousting tournaments, but a bad tourney ended with him horribly crippled | he used to rob graves, but when he got caught a parishioner broke more of his bones than he knew a skeleton even had | he dabbled in {the arcane arts | necromancy} but, made obvious by his near-deathly state, that experiment was shortlived | he was once a successful gambler, but as it turns out not paying back your debts is bad for business - and your bones | he once sang as a minstrel, but when his voice gave out mid-song a lord had him brutally tortured | he used to catch rats for a living, but apparently a giant rat paid him a vengeful visit in the night | he once served a lord, but after dropping a plate of food he was sent to the dungeons where he was promptly forgotten for years | he once killed a man, sure, but that he deserved a better fate than the irreversible torture he received as punishment | he used to hunt witches, but a cruel mistress tricked him into drinking a concoction which crippled his very bones | he once deserted an army and, obviously, got caught | he used to juggle for royalty until he accidentally fell down some steps in the middle of a stunt. The steps proved rather edgy against his bones, it seems | he was born with a horrific deformity | his father brutally attacked him for not living up to his image | his mother scarred him with endless torture | his siblings tortured him all his life}. {The man looks so weak you can almost see his mortal coil flapping in the wind. | Hiring him would almost certainly be the man\'s doom. How merciful! | You don\'t want to be seen as hiring just anybody, but if this guy is a nobody, does that still count as \'anybody\'? | You\'ve seen dead people who look better than this man. | This guy is wolf-lunch on two legs. | The good news is that if he comes back from the dead he shouldn\'t be too hard to put down a second time. | Dreams and inanimate objects are more threatening than this poor git. | To be honest, you\'d rather hire a child, but apparently people look down on that so here we are instead. | And you thought %randombrother% smelled bad. | Hiring a man such as this would send anyone\'s moral compass spinning. | Oh c\'mon, look at him! Are the %companyname% really that in need of warm bodies? | Hiring this man just wouldn\'t be right. Whelp, here goes. | A pair of crutches has more value than this poor man. | This man is in such a sorry state he can play dead standing up.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-20,
				-10
			],
			Bravery = [
				0,
				0
			],
			Stamina = [
				-10,
				0
			],
			MeleeSkill = [
				-5,
				-5
			],
			RangedSkill = [
				-5,
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
				-25,
				-10
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/knife"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/wooden_stick"));
		}

		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}

		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			local item = this.new("scripts/items/helmets/hood");
			item.setVariant(38);
			items.equip(item);
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;
	}

});

