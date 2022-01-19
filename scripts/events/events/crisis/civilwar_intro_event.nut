this.civilwar_intro_event <- this.inherit("scripts/events/event", {
	m = {
		Town = null,
		NobleHouse = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_intro";
		this.m.Title = "A %townname%";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]Vous entrez dans %townname% et trouvez un groupe de villageois debout autour d\'une plate-forme en bois. Pensant qu\'il y a une pendaison à voir, vous vous frayez un chemin à travers la foule. Ce que vous trouvez à la place, c\'est un homme étrangement vêtu qui aboie des nouvelles aux habitants de la ville.%SPEECH_ON%Une décision a été prise entre les maisons nobles %noblehouse1% et %noblehouse2% ! Ils sont arrivés à une conclusion à laquelle tous les partis peuvent s\'entendre : ils se détestent !%SPEECH_OFF%Des chuchotements nerveux froissent la foule. Au fur et à mesure que le volume monte, les chuchotements se transforment en silence. Le ménestrel continue.%SPEECH_ON%C\'est vrai, mon beau peuple ! La guerre est sur nous ! Ah oui, cette bête volage qui sommeille en tous les hommes. Une affaire triste, une affaire juste, une affaire honorable !%SPEECH_OFF%Un vieil homme debout devant vous grogne et crache. Il part en secouant la tête et en murmurant pour lui-même. Le ménestrel continue, son excitation ne correspondant pas aux visages terrifiés devant lui.%SPEECH_ON%Ne traînons pas dans la cérémonie. On m\'a ordonné de parler ainsi : hommes, prenez les armes où vous le pouvez, labourez les champs tant que vous ne le pouvez pas. Femmes, élevez bien vos fils, de peur qu\'ils ne lèvent une épée de travers !%SPEECH_OFF%Enfin, le ménestrel prend une grande inspiration.%SPEECH_ON%Et ceux d\'entre vous qui souhaitent gagner une bonne couronne ou deux, les maisons nobles recherchent les bons services de tout homme qui peut manier une épée. Ceux d\'entre vous de moindre honneur, vous qui lâchez la bride, volez la mariée, vendez des sangsues, fumez, ne faites pas de puits, obsédés par le vice et déchaînés, brigands, bandits et diplômés voleurs, vous êtes maladifs et empoisonnés, les maudits et enragés, guéris et insipides, vendeurs d\'épées et poètes vendant des mots, ceci, mes beaux hommes distingués, est VOTRE temps. Allez là-bas, combattez pour les nobles et gagnez une nouvelle vie ! Dommage qu\'une guerre ne dure pas éternellement, alors faites-le vite !%SPEECH_OFF%Il semble que l\'avenir de %companyname% s\'éclaire - en raison des tonnes d\'or que vous êtes sur le point de gagner.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La guerre est sur nous.",
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
		if (this.World.Statistics.hasNews("crisis_civilwar_start"))
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();
			local nearTown = false;
			local town;

			foreach( t in towns )
			{
				if (t.isSouthern())
				{
					continue;
				}

				if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
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
			this.m.NobleHouse = this.m.Town.getOwner();
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_civilwar_start");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"noblehouse1",
			this.m.NobleHouse.getNameOnly()
		]);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		local noblehouse2;

		do
		{
			noblehouse2 = nobles[this.Math.rand(0, nobles.len() - 1)];
		}
		while (noblehouse2 == null || noblehouse2.getID() == this.m.NobleHouse.getID());

		_vars.push([
			"noblehouse2",
			noblehouse2.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.NobleHouse = null;
	}

});

