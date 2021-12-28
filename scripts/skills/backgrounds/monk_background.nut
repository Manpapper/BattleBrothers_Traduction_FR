this.monk_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.monk";
		this.m.Name = "Monk";
		this.m.Icon = "ui/backgrounds/background_13.png";
		this.m.BackgroundDescription = "Monks tend to have a high resolve in what they do, but are not used to hard physical labor or warfare.";
		this.m.GoodEnding = "%name% the monk retired back into calmer spiritual duties. He is currently out in a mountain monastery, enjoying the quiet while reflecting on his time in the mercenary company. The other monks hate him for fighting and killing, but he\'s penning a world-changing tome on the balance between peace and violence.";
		this.m.BadEnding = "After having a spiritual breakdown, %name% retired from fighting and found home in a monastery. All his fellow brothers and abbots ostracized him for taking part in such a violent venture. Word has it he was eventually exiled when a sexton caught him stealing an offertory.";
		this.m.HiringCost = 60;
		this.m.DailyCost = 5;
		this.m.Excluded = [
			"trait.weasel",
			"trait.hate_beasts",
			"trait.swift",
			"trait.impatient",
			"trait.clubfooted",
			"trait.brute",
			"trait.gluttonous",
			"trait.disloyal",
			"trait.cocky",
			"trait.quick",
			"trait.dumb",
			"trait.superstitious",
			"trait.iron_lungs",
			"trait.craven",
			"trait.greedy",
			"trait.bloodthirsty"
		];
		this.m.Titles = [
			"the Pious",
			"the Monk",
			"the Scholar",
			"the Preacher",
			"the Devoted",
			"the Quiet",
			"the Calm",
			"the Faithful"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.Monk;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Monk;
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
		return "{After raiders murdered his family, %name% retreated into the comforts of religion and became a monk at a nearby monastery. | Often traveling away from his church and fellow monks, %name% spent years preaching to peasantry in remote villages. | %name%, a quiet monk, has spent untold days worshipping the old gods in %townname%\'s monastery. | One monk amongst many, %name% used to wander the steepled temples of %randomtown%. | Abandoned on the steps of a monastery, %name% grew up in the company of monks, and soon took to their lifestyle. | Trying to find peace in a land of ruin, %name% became a monk. | Always an unruly child, %name%\'s parents handed him over to the local monastery where he was quickly pacified as a monk.} {Unfortunately, his abbot\'s liking for youth and fleshen things led to a terrible scandal. %name% fled to preserve his life and his faith. | But his faith was irreversibly damaged as a hellacious attack by raiders left men castrated, women raped, and children skewered on spits. | Though a believer in the old gods, the monk could not stand what atrocities his head priest committed in their name. The monk eventually left to seek spirituality on his own terms. | As the world\'s suffering grew, %name%\'s abbot requested that he go out and heal the people of the earth - or kill those who did them wrong. | Cults of death, beasts of nightmare, and men of cruelty. %name% left the halls of his temple to purify them all. | But when a child asked him a faith-shattering question, %name% abandoned his faith, seeking out spirituality by other means. | Unfortunately, prayer did not spare his brothers from a slaughter. %name% realized that his faith was better invested in looking out for himself than muttering to some so-called god. | Always a fiery man, %name% left the safety of the monasteries to go out and \'right\' the world. | One of the few literate men around, %name% abandoned his ascetic life to learn more of the world and, hopefully, to cure that which sickened it. | But one night a woman bedded him. He woke with his faith cratered in the crumpled sheets around him. Ashamed, he never returned to his monastery. | But he used his trusted position for ill-gotten gains, stealing from the temple\'s treasury. It didn\'t take long for the scandal to drive him out. | Unfortunately, a child accused him of behavior unbecoming of a monk. Nobody knows the truth behind the story, but %name% did not last much longer at the church. | One night, he discovered an awful truth in an old tome. Not long after, %name% quickly left the church, never quite saying what it was that he discovered.} {The man hardly knows a thing about fighting, but he carries the mental fortitude of a mountain standing against a storm. | Years of solitude and prayer have left %name% out of shape, but it is his steeled mind that is of most value. | Perhaps never really content with his life, it\'s difficult to entirely know why someone like %name% would join a band of mercenaries. | Maybe there are too many devils in the world, or too many inside him, but you don\'t question why %name% wishes to join a band of sellswords. | Faith won\'t cleave a greenskin, but it won\'t have a man like %name% running away from one, either. | %name%\'s stated desire to rid the world of \'the unfaithful\' is almost scary in its determination. | While %name%\'s spirituality is to be commended, the constant mutterings to the old gods are a bit annoying. | While %name%\'s hands are better clasped in prayer than around the handle of a sword, few mercenaries have the sense of resolve that he does. | A holy book practically anchored to his wrist, %name% has sought the company of sellswords. | The holy book he carries is thick enough to be used as a shield, but %name% looks absolutely horrified when you say as much out loud. | Perhaps with a romantic view of mercenaries in need of a good spiritual cleansing, %name% seeks to accompany sellswords. | Once having read of warrior priests, %name% now wishes to emulate those brave, unwavering soldiers of faith. | You get the feeling %name% wants release from this sinful world. If that\'s the truth then he has come to the right place.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				11,
				11
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
		items.equip(this.new("scripts/items/armor/monk_robe"));
	}

});

