this.vulcano_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.vulcano_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_151.png[/img]{Empire\'s End. Metropolis of Ash. The Annihilation.\n\nWhatever its name, the ancient city is now a vast grey ruin. It sits beneath a mountain missing a peak, its once glorious shape obliterated in an enormous eruption. The explosion hit with such violence that shockwaves unfurled cobbled streets and sent the bricks showering over the city proper. Enormous granitic boulders cratered neighborhoods whole and boiling debris vaporized all in its way. The flow of lava came last, smoldering much of the city in a black sludge, the edges of which pillowed and toed in bulbous contours until it looked as though a cloud of black smoke had solidified. It is a horrid sight to behold, in part because the earthen rage also captured many victims in perpetuity: grey casts of ancient humans still stand to this day, posed in manners most lively like pairs shaking hands, one looking over a stove, another petting a dog.\n\nOf course, it is wholly within man\'s nature to see such relics of destruction and, distant as they are from its reality, flock to its remains, and vicariously revivify the violence through means of faith. Followers of the Gilder see it as a warning to not fall for profligacy and greed. Northerners see it as a clash between old gods, a rarity since the dawn of man. One faith or the other, both reside here in mutual respect for those whose lives were lost... respectful for now, at least.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Our fate will lead us here again in time.",
					function getResult( _event )
					{
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

	function onClear()
	{
	}

});

