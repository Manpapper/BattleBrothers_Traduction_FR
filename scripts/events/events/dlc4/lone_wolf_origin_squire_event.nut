this.lone_wolf_origin_squire_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.lone_wolf_origin_squire";
		this.m.Title = "At %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_20.png[/img]The pub is full of drunk denizens sloshing about, cheering, singing, carousing with the womenfolk of either wench or wife or whore. A man with a lute dances and plays and another with metal cymbals crashes overhead while a fat man booms with songs of battles or love, and whether a tale of victory or defeat they provoke rounds of ale and more merriment all the same.\n\n You leave the pub and enter the next building over. The wind whistles down a pew filled nave as you stand at the door. A man sweeping the stone floor looks up for a time then continues with his work. Another man cheerfully crosses the room and asks if you\'d like to pray. You decline and he purses his lips and crosses his arms. The crowd next door roars with drunken delight as though to make a mockery of you both and then he moves on. You stay for a moment longer and then leave and go back out to the town center and squat on a series of steps. It seems there used to be a statue at the top of those steps, but vandals and raiders alike have made short work of another\'s artisanry. You fall asleep there at the foot of impermanence. \n\n Waking from a nap, you find a young man at the bottom of the steps. He says he knows you\'re a knight and he\'s come to offer his services as a squire.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Have you killed anyone?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "What can you do?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "I take you as my squire.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "I work alone.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"squire_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "You met %name% in " + _event.m.Town.getName() + " where he volunteered to be your squire. He probably had no idea what he was getting into back then.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Body));
				_event.m.Dude.getItems().equip(this.new("scripts/items/armor/linen_tunic"));
				_event.m.Dude.setTitle("the Squire");
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_20.png[/img]{The man shakes his head no.%SPEECH_ON%Ain\'t never killed no one, sir.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What can you do?",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "I take you as my squire.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "I work alone.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_20.png[/img]{The man stands up straight.%SPEECH_ON%I know how to sharpen steel and mend leather. I can disassemble and reassemble heavy and light armors both, no matter how complex or simple, and I can do it fast. If we have a horse.%SPEECH_OFF%You interrupt.%SPEECH_ON%I walk.%SPEECH_OFF%Shifting uneasily on his feet, the man continues.%SPEECH_ON%Alright. Well I can cook. I can cook a fine meal whether I got the ingredients or not. I make do. And. And. That\'s. That\'s about it. But I\'m willing to learn!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Have you killed anyone?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "I take you as my squire.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "I work alone.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_20.png[/img]{You ask the man his name. He swallows nervously.%SPEECH_ON%%squire%, sir.%SPEECH_OFF%You nod.%SPEECH_ON%Well alright then. I\'ll take ya with me.%SPEECH_OFF%He smiles.%SPEECH_ON%That\'s. That\'s it?%SPEECH_OFF%You nod.%SPEECH_ON%Yeah. That\'s it.%SPEECH_OFF%%squire% looks around.%SPEECH_ON%Well. Alright. What now?%SPEECH_OFF%You lean back against the stone steps.%SPEECH_ON%You follow me. Right now I\'m gonna take another nap. If yer still around when I wake, well, then you\'ve passed your first test. Defeating boredom.%SPEECH_OFF%The squire is grinning ear to ear. He\'s still there when you wake.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Now I need a drink.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude.m.MoodChanges = [];
						_event.m.Dude.improveMood(1.0, "Has become a squire to a knight");
						_event.m.Dude.getFlags().set("IsLoneWolfSquire", true);
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_20.png[/img]{You look at the would-be squire long and hard and then tell him no. He shrugs.%SPEECH_ON%Just so you know, you ain\'t gotta be alone in this world. Loneliness has no presence. It is not a place. It is not a being. It is action!%SPEECH_OFF%Spitting, you wipe your face and laugh.%SPEECH_ON%Is that what you tell yourself every morning? Get out of here.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I need a drink.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.lone_wolf")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() > 1)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (!t.isSouthern() && t.getTile().getDistanceTo(playerTile) <= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Town = town;
		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"squire",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Town = null;
	}

});

