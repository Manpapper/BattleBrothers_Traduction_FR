this.meteorite_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.meteorite_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_154.png[/img]{A cataclysm as the world knows it comes from the earth herself. Volcanos, floods, earthquakes, plagues, these are things all men fear. The unwarned issuances that can instantly shatter the greatest of kingdoms and disrobe the royal color from the greatest of kings.\n\nThe great caldera before you, then, stands as a stark reminder that not only are you small, but you might not even know just how small you are: it is quite clear to even the simplest of minds that the enormous rock at the crater\'s center came from above. Perhaps very far above. Northerners believe it is the coda of the great war of the old gods. It is a literal mountain weaponized by the deities, thrown like a stone from a catapult before landing with such apocalyptic damage that the horrors wrought ceased all heavenly conflict. Southerners see it as the \'fiery tear\' of the Gilder. Looking down upon a world without man, the God fell into deep sadness and cried upon the earth. At first He was fearful that he had destroyed all that lay below, but instead He watched as Man drew up from the fires and armored himself in the ashes. And it is then that He knew Man, living in every corner of the earth, was His chosen beings, and Man knew Him.\n\nWhatever it is, the crater brings followers and believers from all directions. Here exists an amicable understanding that there shall be no impasses upon one another, though during times of religious war that unspoken agreement is oft shattered.}",
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

