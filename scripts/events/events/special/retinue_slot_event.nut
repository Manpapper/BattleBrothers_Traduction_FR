this.retinue_slot_event <- this.inherit("scripts/events/event", {
	m = {
		LastSlotsUnlocked = 0
	},
	function create()
	{
		this.m.ID = "event.retinue_slot";
		this.m.Title = "Along the way...";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{The prestige and renown of the %companyname% is growing. Everywhere you go, people are looking to join - and not just sellswords, but followers who may be of other use! | With every battle your sellswords fight, the renown of the company grows. As this fame rises, more people, and not just sellswords, will be looking to join the %companyname%. Perhaps it is time the company takes on another follower? | Followers of the %companyname% need not just be fighters - it appears that with the company\'s growing renown and prestige there may be others willing to ride the coattails. Perhaps these tagalongs may be of great utility to the company, even if they are not contributing on the battlefield.}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I\'ll take a look at our retinue!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local unlocked = this.World.Retinue.getNumberOfUnlockedSlots();

		if (unlocked > this.m.LastSlotsUnlocked && this.World.Retinue.getNumberOfCurrentFollowers() < unlocked)
		{
			this.m.Score = 400;
		}
	}

	function onPrepare()
	{
		this.m.LastSlotsUnlocked = this.World.Retinue.getNumberOfUnlockedSlots();
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

	function onSerialize( _out )
	{
		this.event.onSerialize(_out);
		_out.writeU8(this.m.LastSlotsUnlocked);
	}

	function onDeserialize( _in )
	{
		this.event.onDeserialize(_in);
		this.m.LastSlotsUnlocked = _in.readU8();
	}

});

