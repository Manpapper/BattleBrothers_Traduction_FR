this.monolith_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.monolith_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_101.png[/img]{From a distance, the Black Monolith looked like a black tower tilting from the earth. The sky above was without blemish, as though the clouds and the birds were circumventing some unseen mountain. A numbness settled its hinterland, terra neither dying nor growing, and a cruel silence left the listless life worse than no life at all. Adventurers went to it and did not return. Stories of their demise stacked high until their absence shielded the monolith whole, clothing it in such fear and menace no one dared go near.\n\n But now the %companyname% stands before the obelisk like ants at the steel of a staked sword. Here you see that the structure was not built upon the earth at all: the obelisk rests in the pit of an abandoned quarry. Roads and paths sidewinder into the depths like some great and hollow terra socket. Ropes carrying buckets hang across every gap, innumerable pails of dirt left listing like fireless lanterns on a festive night. More bindings hold the frames of bridges, the walkway planks long since fallen, and more yet wrap about the monolith as though a great bevy of men had attempted to pull it down or perhaps even correct its tilt. At the bottom of this abandoned pit is the base of the monolith, but to you this is only a guess. It has every appearance of never stopping its descent into the very earth and whatever is below. Shovels and pickaxes litter about its obsidian walls with soil still clumped on their metals. %randombrother% nods at the scene.%SPEECH_ON%Looks like whoever was digging there got interrupted.%SPEECH_OFF%The man\'s words carry far into the quarry and there become so presently shaped in echo that you just about watch them go. Looking back, you see that the silence itself has followed you in, but even here at the edge of the pit it is pensive and cut with ease. The decision to enter the quarry rests heavy on your shoulders.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Go in.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Fall back.",
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
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_101.png[/img]{Halfway into the quarry and rounding a long bend, you notice a series of hallways cut into the lower wall. You cast up a fist. The company seizes, bumbling into one another as the formation comes to a stop. %randombrother% asks what\'s wrong. You put a finger to your lips. \n\n With the lightest of steps you approach one of the ropes strung between this level and the very bottom of the pit. A pail filled with soil totters the tether as though jittered by your appearance. The pulley used to draw it up and down has long since rusted over. You draw your sword and cut the rope. The binding shoots back like a whip and the bucket plummets. It clatters side to side off the rocks until striking the ground with a metal pang and a cloud of dust. And just like that, the silence is gone.\n\n Pale men flood out of the hallways below, a stream of malignant miners and ditch diggers in haggard drawers and boots and capes of shredded shirts, shambling back out as though returning to some long gone work left incomplete. You try and count their numbers but are mightily distracted when a throng of armored soldiers march out behind the mob, this outfit carrying polearms, shields, spears and, most dangerously of all, a sense of cohesion.\n\n No point in running out of the quarry. Nothing in the land to run to. When you look back at the men, they\'re already drawing out their weapons. %randombrother% nods.%SPEECH_ON%With you to the end, captain.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To the end!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						}

						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

