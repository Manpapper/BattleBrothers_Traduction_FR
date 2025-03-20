this.graverobber_finds_item_event <- this.inherit("scripts/events/event", {
	m = {
		Graverobber = null,
		Historian = null,
		UniqueItemName = null,
		NobleName = null
	},
	function create()
	{
		this.m.ID = "event.graverobber_finds_item";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Le temps est agréable. Une belle soirée, si tant est qu\'il y en ait une, pour que la lune soit là où elle est : une croûte orange qui se glisse dans les nuages et en sort - des nuages qui passent sur le geste apparemment inoffensif que peut avoir une brise légère. Ce bord de lune est si brillant que l\'on se demande si des fleurs ne vont pas éclore, confondant la lumière du soir avec sa cousine plus brillante. Vous vous demandez si les papillons de nuit, les mouches et les scarabées à dos rayé voient la lune et dansent vers elle comme ils le feraient avec une bougie ou une torche. Ont-ils ce désespoir tranquille ? Cette cruauté inéluctable de réaliser que, lorsque votre personne est placé contre le grand tout, vous n\'avez et n\'êtes rien... et la haine que cette réalisation peut apporter, et la jalousie...\n\n Soudain, %graverobber% le pilleur de tombe apparaît à vos côtés, son odeur embrouillant vos pensées avec une compétence miasmique. Ce n\'est pas vraiment un homme, mais un golem, couvert de boue et d\'herbe, avec deux yeux blancs. En soupirant, vous demandez ce qu\'il veut. Il vous regarde par-dessus une épaule, l\'autre étant occupée par une pelle.%SPEECH_ON%Je suis allé creuser dans une ou trois tombes. J\'ai trouvé quelque chose et je ne parle pas de ce à quoi servent ces tombes. Tu veux venir jeter un coup d\'oeil ?%SPEECH_OFF%Bien sûr que vous le voulez...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons voir...",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());

				if (_event.m.Historian != null)
				{
					this.Options.push({
						Text = "Allons chercher %historian% l\'Historien, il saura tout sur les trésors enfouis.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]%graverobber% vous amène à un grand trou dans le sol. La moitié supérieure d\'un squelette se trouve au fond, les bras relâchés sur la terre comme s\'il s\'était couché là pour une nuit de repos. Des orbites vides vous regardent. Le fossoyeur s\'accroupit et attrape quelque chose. Il essuie la boue et les vers et vous le donne.%SPEECH_ON%Je pense que nous pouvons l\'utiliser.%SPEECH_OFF%Vous acquiescez, mais dites à l\'homme de remplir rapidement la tombe avant que quelqu\'un ne voit ce qu\'il a fait.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Il n\'en a plus besoin.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Graverobber.getImagePath());
				local r = this.Math.rand(1, 8);
				local item;

				if (r == 1)
				{
					item = this.new("scripts/items/weapons/bludgeon");
				}
				else if (r == 2)
				{
					item = this.new("scripts/items/weapons/falchion");
				}
				else if (r == 3)
				{
					item = this.new("scripts/items/weapons/knife");
				}
				else if (r == 4)
				{
					item = this.new("scripts/items/weapons/dagger");
				}
				else if (r == 5)
				{
					item = this.new("scripts/items/weapons/shortsword");
				}
				else if (r == 6)
				{
					item = this.new("scripts/items/weapons/woodcutters_axe");
				}
				else if (r == 7)
				{
					item = this.new("scripts/items/weapons/scramasax");
				}
				else if (r == 8)
				{
					item = this.new("scripts/items/weapons/hand_axe");
				}

				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Tout en regardant les marchandises, %historian%, l\'érudit et historien plutôt avisé, s\'approche de vous. Il se frotte le menton et un léger ronronnement rumine profondément en lui.%SPEECH_ON%Oui, oui...%SPEECH_OFF%Vous vous tournez vers lui pour lui demander de quoi il s\'agit. Il claque des doigts et vous montre du doigt ce que le pilleur de tombes a trouvé. Il explique que ce n\'est pas n\'importe quelle plaque de poitrine ou arme, mais bien l\'équipement d\'un célèbre combattant, noble et coureur de jupons, %noblename%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Fascinant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local item;
				local i = this.Math.rand(1, 8);

				if (i == 1)
				{
					item = this.new("scripts/items/shields/named/named_bandit_kite_shield");
				}
				else if (i == 2)
				{
					item = this.new("scripts/items/shields/named/named_bandit_heater_shield");
				}
				else if (i == 3)
				{
					item = this.new("scripts/items/shields/named/named_dragon_shield");
				}
				else if (i == 4)
				{
					item = this.new("scripts/items/shields/named/named_full_metal_heater_shield");
				}
				else if (i == 5)
				{
					item = this.new("scripts/items/shields/named/named_golden_round_shield");
				}
				else if (i == 6)
				{
					item = this.new("scripts/items/shields/named/named_red_white_shield");
				}
				else if (i == 7)
				{
					item = this.new("scripts/items/shields/named/named_rider_on_horse_shield");
				}
				else if (i == 8)
				{
					item = this.new("scripts/items/shields/named/named_wing_shield");
				}

				item.m.Name = _event.m.UniqueItemName;
				this.World.Assets.getStash().makeEmptySlots(1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_graverobber = [];
		local candidates_historian = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.graverobber")
			{
				candidates_graverobber.push(bro);
			}
			else if (bro.getBackground().getID() == "background.historian")
			{
				candidates_historian.push(bro);
			}
		}

		if (candidates_graverobber.len() == 0)
		{
			return;
		}

		this.m.Graverobber = candidates_graverobber[this.Math.rand(0, candidates_graverobber.len() - 1)];

		if (candidates_historian.len() != 0)
		{
			this.m.Historian = candidates_historian[this.Math.rand(0, candidates_historian.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
		this.m.NobleName = this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)];
		this.m.UniqueItemName = this.m.NobleName + "\'s Shield";
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"graverobber",
			this.m.Graverobber.getNameOnly()
		]);
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
		_vars.push([
			"noblename",
			this.m.NobleName
		]);
		_vars.push([
			"uniqueitem",
			this.m.UniqueItemName
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Graverobber = null;
		this.m.Historian = null;
		this.m.UniqueItemName = null;
		this.m.NobleName = null;
	}

});

