this.golden_goose_event <- this.inherit("scripts/events/event", {
	m = {
		Observer = null
	},
	function create()
	{
		this.m.ID = "event.location.golden_goose";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_125.png[/img]{The ship is wrecked amongst the trees some of which have long since started to grow through it. As far as you\'re aware, there is neither sea nor river for miles. %observer% walks up and halts at the very sight.%SPEECH_ON%By the old gods, is that a ship?%SPEECH_OFF%You sigh and tell the company to stay here while you and the very observant sellsword go take a look.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s see what secrets are inside.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "It\'s not worth investigating now.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_125.png[/img]{You step into the bowels of the ship. It\'s completely vacant save for a stump with an axehead chopped into it. %observer% looks at it.%SPEECH_ON%There\'s an axehead.%SPEECH_OFF%Nodding, you say there it is indeed. But the metal of it carries veins of a sort of golden hue. Getting closer to the stump, you can see embers flittering upward out of the wedge. %observer% taps your shoulder and you find him pointing into the dark of the ship.%SPEECH_ON%Skeleton. Dead one.%SPEECH_OFF%Just faintly can you see the pale bones. As you draw near, the clothing becomes apparent, and readily obvious as royal attire. There is a cracked ale horn in one hand and a molded loaf of bread in the other. His jacket is blown open and shredded by splinters. Upon closer inspection, some of the wood is embedded in his brainpan.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Inspect the stump.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Let\'s get out of here.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_125.png[/img]{Seeing as how the skeleton and his beer and bread ain\'t going anywhere, you leave it be. The axehead however draws your eye again. %observer% walks over to the stump and the glowing wedge. He tries to take it out. Finding no luck there, he steps back and kicks it further in. The trump cracks in twain and the sellsword suddenly flies upside down and the axehead shoots through the roof of the boat and you can hear it clunk and clatter down its sides outside. Debris and smoke drift lazily about. The sellsword gets up and pats himself off.%SPEECH_ON%What in all the hells was that?%SPEECH_OFF%You shush him and point. A little golden goose squats where the stump\'s base used to be. The sheen of its metal glows and swirls. You\'ve heard stories of a golden goose, but never thought they were anything beyond that!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Is it real?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_125.png[/img]{%observer% stumbles forward.%SPEECH_ON%Sir, what are you doing?%SPEECH_OFF%You wave him off and pick the golden goose up. Holding it in both hands, it feels oddly warm. And it isn\'t exploding or melting your face. You can feel its metal rippling ever so slightly against your fingers. It might even be growing? With the treasure safely huddled beneath your elbow, you wonder why the skeleton didn\'t fare better. %observer% walks up and touches the golden goose on the head, but quickly recoils. You ask if it burned him. The sellsword purses his lips.%SPEECH_ON%Really, sir? Was it not obvious?%SPEECH_OFF%He sticks his finger in his mouth. You tell him to not be so snappy with his commander or you\'ll throw the goose at him and see if it makes short work of him as it did the skeleton. The man shrugs.%SPEECH_ON%Oh look at the man chosen by a shiny bauble, put a blade beneath a wing so it can knight ye, or hells why not put it on yer head and call yerself king already?%SPEECH_OFF%You look down at the goose. A drop of red blood runs down its length, turns gold, and drops to the ground with a tiny plink. You pick it up and bite it. The gold smooshes satisfyingly in your teeth and you then throw it to %observer%. It does not burn him this time, and you realize you may have found the genuine Golden Goose from the tales!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The tales tell true!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/special/golden_goose_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain the " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getBackground().isNoble() && !bro.getSkills().hasSkill("trait.bright") && !bro.getSkills().hasSkill("trait.short_sighted") && !bro.getSkills().hasSkill("trait.night_blind"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Observer = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		else
		{
			this.m.Observer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"observer",
			this.m.Observer != null ? this.m.Observer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Observer = null;
	}

});

