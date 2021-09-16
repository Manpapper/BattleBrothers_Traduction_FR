this.cultist_origin_flock_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_flock";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%joiner%, a wandering devotee of Davkul, has come to join the %companyname%. The company gathers around him, he nods, they nod back, and just like that he is with you. | %joiner%, a man in rags, yet armored in the shadows of Davkul, has joined the %companyname%. | A man by the name of %joiner% shows you his dedication to Davkul, a series of spiritual rites shaped about his skull as gruesome scars. He is welcomed into the %companyname%. | %joiner% stalked the company for a time before approaching you directly. He is an advocate for Davkul\'s purpose, and with that his argument has been made and yourself engendered to it all the same. The man joins the company. | Davkul surely watches over you as a man by the name of %joiner% joins the %companyname%. He stated that he had but one purpose and it was to find you and ensure that this world sees all that awaits it. | %joiner% says that he saw the shadows flicker behind your body as though they were \'of flame.\' He states that he will join your cause for surely Davkul has embedded in you an aspect of the dark and infinite. | %joiner% walks beside you. He calls you an aspect of Davkul\'s darkness, and that eternal eyes surely watch over your party whole. The %companyname% takes him beneath its many shadowed wings. | %joiner% finds the %companyname% on the march and joins its ranks as though he were no stranger at all. No one says a word and you simply direct him to the inventory where his purpose may gather teeth. | With a showing of his scarred head, %joiner% states he is at the speartip of Davkul\'s purpose. You nod and welcome him into the %companyname%. | Walking in the shadow of Davkul, you were bound to find men such as %joiner%. He is keen on joining the company, in particular because you are in command of it, and more particularly because he believes Davkul has chosen you. | %joiner% bands with the company and there is little argument as to why. When asked where he came from, he shrugs and speaks of Davkul while nodding knowingly in your direction.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Yes, join us.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cultist_background"
				]);
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

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		this.m.Score = 75;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"joiner",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

