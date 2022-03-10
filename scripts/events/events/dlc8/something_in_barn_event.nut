this.something_in_barn_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		BeastSlayer = null,
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.something_in_barn";
		this.m.Title = "Along the way...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_115.png[/img]{A man comes to the company saying that there\'s an evil direwolf pup trapped in his barn. %anatomist% the anatomist overhears this and slides on over. He asks if he knows for a certainty that the pup is evil. The stranger nods.%SPEECH_ON%Part direwolf, I imagine that its pedigree is clothed in evil. Damn thing is holed up in the barn and there\'s only one way in, so the whole affair is damn bit prickly.%SPEECH_OFF%He asks that you go and kill the pup before it escapes. %anatomist% is quite curious about this endeavor as very little is known about direwolves when they\'re young. He elects himself as volunteer to go with you to see to this infantile creature.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let\'s go see it.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 55 ? "B" : "C";
					}

				},
				{
					Text = "Not our business.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				if (this.Const.DLC.Unhold && _event.m.BeastSlayer != null)
				{
					this.Options.push({
						Text = "%beastslayer% the beast slayer should handle this.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Farmer != null)
				{
					this.Options.push({
						Text = "Our resident farmer %farmer% seems to have an idea.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_27.png[/img]{You take up the stranger\'s request and head over to the barn. It\'s fairly nondescript, and he explains that there\'s only one way in. He leans against the door and listens, then nods.%SPEECH_ON%Oh yeah, it\'s still in there alright.%SPEECH_OFF%The door is opened and you and %anatomist% venture in, passing piles of shite and stalls with spooked animals crammed into corners and rearing their heads as you pass. You see at the far end of the barn that there\'s a slovenly creature rummaging in a pile of hay. %anatomist% panics and snatches up a pitchfork and goes charging forth. You stave him off, catching the pole and riding it into the air. You yell at him and then point down. The beast isn\'t a direwolf at all, but just a regular dog, the mutt itself staring up with teary eyes. The man stands behind you rubbing the back of his neck.%SPEECH_ON%Oof, ah, yeah, that is my bad. I was sure this was a wolven monstrosity.%SPEECH_OFF%With a bit of food and training, there\'s little doubt that this mutt could be made into something useful for the %companyname%.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Just keep it away from %anatomist%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]{You venture over to a nondescript barn with chains across its door. The man leans against the frame for a moment, listening through it, then nods and takes the chains off. As he swings the door open, he retreats behind you and stares from this safe position.%SPEECH_ON%It\'s there, in the hay.%SPEECH_OFF%You see the shape of the beast and, drawing your sword, you creep forward. %anatomist%, however, jolts at the very sight of it, losing all composure with a graceless yelp and womanly cry. He grabs a pitchfork and stabs it into the hay. There\'s a shriek of the beast as the anatomist repeatedly thrusts the prongs in, again and again until the creature is slain. You crouch down and pick way the bloody straw. It isn\'t a direwolf at all, not even a hint of a small pup. It is in fact just a regular dog, and regularly dead at that.\n\nJust then, you hear a voice behind you. It isn\'t the man who fetched you at all, but instead someone else. He cries out that you killed his dog. %anatomist% throws the pitchfork down. He explains that this was all a mistake. Seeing as how the anatomist elected to arbitrate the situation himself, you hurriedly leave the scene to him, only hearing the faint cries of the dog\'s owner and %anatomist% trying to argue that it was all an accident. You\'ve mind to find the bastard who set you up in the first place, but you got the feeling he\'s made himself very scarce. All you can do is go count some inventory while ignoring the wailings of the dead dog\'s owner and %anatomist%\'s pitiful gainsaying.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oof.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(0.75, "Accidentally killed someone\'s dog");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_131.png[/img]{If it is indeed a beast, it\'s probably best %beastslayer% the actual slayer of beasts comes along. You all three go to the barn. After standing in silence, for a time, you count to three and you and the beast slayer kick the barn doors open. The anatomist is late and didn\'t even realize this was the plan and kicks last and way too late and finds his boot pushing air and his leg plants and scissors horribly across the barnfloor. He tries to regain his dignity and get back up, but it appears he\'s pulled a muscle in his groin. You and %beastslayer% burst out laughing. As you help the anatomist up, the beast slayer ceases all musings and there\'s a rush of movement and a burst of air and a hard thwack against one of the barn\'s stalls. You look over to see the beast slayer pinning a pale, ghoulish creature, his weapon bored through its skull as his arm pins it by the neck.%SPEECH_ON%It\'s a pup alright, but it sure as shite ain\'t a direwolf.%SPEECH_OFF%He says, and drops the small nachzehrer to the ground. He looks over.%SPEECH_ON%Kinda looks like the anatomist a little bit.%SPEECH_OFF%%anatomist% takes this on the chin, awkwardly getting up and trundling forth in a bowlegged gait. He remarks that the beast could still be of scientific benefit. Despite not being as rough around the edges as some of the other men, you can\'t help but respect his admiration for study.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good job.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/misc/ghoul_teeth_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				_event.m.BeastSlayer.improveMood(1.0, "Put his monster slaying skills to use");

				if (_event.m.BeastSlayer.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.BeastSlayer.getMoodState()],
						text = _event.m.BeastSlayer.getName() + this.Const.MoodStateEvent[_event.m.BeastSlayer.getMoodState()]
					});
				}

				_event.m.Anatomist.worsenMood(0.5, "Embarrassed himself trying to slay a monster");
				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] Experience"
				});
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.BeastSlayer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_131.png[/img]{%farmer% the farmer comes up. He tells the man.%SPEECH_ON%That wasn\'t originally your barn, was it?%SPEECH_OFF%The man shakes his head. %farmer% nods.%SPEECH_ON%Figured as much, because barns like that aren\'t just one way in. There\'s an earthen exit built in, you just have to know where to look. Give me one sec and I\'ll go spur this beast from the back end, you all just be ready for it in the front.%SPEECH_OFF%According to the plan, you all await at the front. It isn\'t long until you hear the yelp of a beast inside and it comes bumbling toward the doors. The second it steps outside you stab a sword through its skull, and as it flips over onto the ground you realize that it\'s a small nachzehrer. %anatomist% claps his hands for he has something that might be worth studying. %farmer% comes back around the sides of the barn holding a long two-handed weapon.%SPEECH_ON%Looks like someone forgot about this when they were auguring out the back of the barn. I think we\'ll go ahead and take it for ourselves as payment, won\'t we?%SPEECH_OFF%You nod, and the man who asked for your assistance gives no protest to the matter.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good job.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local twoHanders = [
					"weapons/woodcutters_axe",
					"weapons/hooked_blade",
					"weapons/warbrand"
				];

				if (this.Const.DLC.Unhold)
				{
					twoHanders.extend([
						"weapons/two_handed_wooden_mallet",
						"weapons/two_handed_wooden_flail",
						"weapons/spetum",
						"weapons/goedendag"
					]);
				}

				local item = this.new("scripts/items/" + twoHanders[this.Math.rand(0, twoHanders.len() - 1)]);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				_event.m.Anatomist.improveMood(1.0, "Got to study an interesting specimen");
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Farmer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_115.png[/img]{Despite %anatomist%\'s desires, you tell the peasant that if it is indeed a direwolf in the barn then he should see to it himself. This sort of trouble isn\'t your concern, and if it will be, then somebody better damn well pay you for it. Hells, maybe the pup direwolf will provide ample opportunities for contract work down the road once it\'s big and strong to scare the peasantry into the %companyname%\'s arms.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We\'re running a business here.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Anatomist.worsenMood(1.0, "Was denied a research opportunity");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary() || t.getSize() >= 2)
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local beastSlayerCandidates = [];
		local farmerCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.beast_slayer")
			{
				beastSlayerCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.farmhand")
			{
				farmerCandidates.push(bro);
			}
		}

		if (beastSlayerCandidates.len() > 0)
		{
			this.m.BeastSlayer = beastSlayerCandidates[this.Math.rand(0, beastSlayerCandidates.len() - 1)];
		}

		if (farmerCandidates.len() > 0)
		{
			this.m.Farmer = farmerCandidates[this.Math.rand(0, farmerCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
		_vars.push([
			"beastslayer",
			this.m.BeastSlayer != null ? this.m.BeastSlayer.getName() : ""
		]);
		_vars.push([
			"farmer",
			this.m.Farmer != null ? this.m.Farmer.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.BeastSlayer = null;
		this.m.Farmer = null;
	}

});

